import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/app/app_event.dart';
import 'package:weather/bloc/main/main_screen_bloc.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/resources/config/dimensions.dart';
import 'package:weather/resources/config/ids.dart';
import 'package:weather/ui/main/widget/weather_main_sun_path_widget.dart';
import 'package:weather/ui/widget/animated_gradient.dart';
import 'package:weather/ui/widget/application_colors.dart';
import 'package:weather/ui/widget/current_weather_widget.dart';
import 'package:weather/ui/widget/loading_widget.dart';
import 'package:weather/ui/widget/widget_helper.dart';
import 'package:weather/utils/datatime_utils.dart';
import 'package:weather/utils/log_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  final Map<String, Widget?> _pageMap = <String, Widget?>{};

  late AppBloc _appBloc;
  late MainScreenBloc _mainScreenBloc;
  late NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of(context);
    _appBloc.add(LoadSettingsAppEvent());

    _mainScreenBloc = BlocProvider.of(context);
    _mainScreenBloc.add(LocationCheckMainEvent());

    _navigationBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BlocBuilder<MainScreenBloc, MainScreenState>(
              builder: (context, state) {
            return Stack(
              children: [
                if (state is InitialMainScreenState ||
                    state is LoadingMainScreenState ||
                    state is CheckLocationMainScreenState) ...[
                  const AnimatedGradientWidget(),
                  const LoadingWidget(),
                ] else ...[
                  _buildGradientWidget(),
                  if (state is LocationServiceDisableMianScreenState)
                    _buildLocationServiceDisabledWidget()
                  else if (state is PermissionNotGrantedMainScreenState)
                    _buildPermissionNotGrantedWidget(
                        state.permanentlyDeniedPermission)
                  else if (state is SuccessLoadMainScreenState)
                    _buildWeatherWidget(state.weatherResponse,
                        state.weatherForecastListResponse)
                ],
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(WeatherResponse weatherResponse,
      WeatherForecastListResponse weatherForecastListResponse) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        key: const Key("main_screen_weather_widget_conainer"),
        decoration: BoxDecoration(
          gradient: WidgetHelper.getGradient(
            sunriseTime: weatherResponse.system!.sunrise,
            sunsetTime: weatherResponse.system!.sunset,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                weatherResponse.name!,
                key: const Key("main_screen_weather_widget_cith_name"),
                style: Theme.of(context).textTheme.headline6,
                textDirection: TextDirection.ltr,
              ),
              Text(
                DateTimeUtils.formatDateTime(DateTime.now()),
                key: const Key("main_screen_weather_widget_date"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(
                height: Dimensions.weatherMainWidgetSwiperHeight,
                child: _buildSwiperWidget(
                    weatherResponse, weatherForecastListResponse),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwiperWidget(WeatherResponse weatherResponse,
      WeatherForecastListResponse weatherForecastListResponse) {
    return Swiper(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _getPage(Ids.mainWeatherPage, weatherResponse,
              weatherForecastListResponse);
        } else {
          return _getPage(Ids.weatherMainSunPathPage, weatherResponse,
              weatherForecastListResponse);
        }
      },
      itemCount: 2,
      loop: false,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: ApplicationColors.swiperInactiveDotColor,
          activeColor: ApplicationColors.swiperActiveDotColor,
        ),
      ),
    );
  }

  ///天气信息页面
  Widget _getPage(String key, WeatherResponse weatherResponse,
      WeatherForecastListResponse weatherForecastListResponse) {
    if (_pageMap.containsKey(key)) {
      return _pageMap[key] ?? const SizedBox();
    } else {
      Widget page;
      if (key == Ids.mainWeatherPage) {
        page = CurrentWeatherWidget(
          weatherResponse: weatherResponse,
          forecastListResponse: weatherForecastListResponse,
        );
      } else if (key == Ids.weatherMainSunPathPage) {
        page = WeatherMainSunPathWidget(
          system: weatherResponse.system,
        );
      } else {
        LogUtil.e("Unsupported key:$key");
        page = const SizedBox();
      }
      _pageMap[key] = page;
      return page;
    }
  }

  ///定位权限未授予
  Widget _buildPermissionNotGrantedWidget(bool permanentlyDeniedPermission) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final String text = permanentlyDeniedPermission
        ? appLocalizations.error_permissions_not_granted_permanently
        : appLocalizations.error_permissions_not_granted;
    return Column(
        key: const Key("main_screen_permissions_not_granted_widget"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorWidget(text, () {
            _mainScreenBloc.add(LocationCheckMainEvent());
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                //TODO：设置按钮
                // AppSettings.openAppSettings();
              },
              child: Text(
                appLocalizations.open_app_settings,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]);
  }

  ///背景色
  Widget _buildGradientWidget() {
    return Container(
      key: const Key("main_screen_gradient_widget"),
      decoration: BoxDecoration(
        gradient: WidgetHelper.buildGradient(
          ApplicationColors.nightStartColor,
          ApplicationColors.nightEndColor,
        ),
      ),
    );
  }

  ///定位服务不可用
  Widget _buildLocationServiceDisabledWidget() {
    return _buildErrorWidget(
      AppLocalizations.of(context)!.error_location_disabled,
      () {
        _mainScreenBloc.add(
          LocationCheckMainEvent(),
        );
      },
      key: const Key("main_screen_location_service_disabled_widget"),
    );
  }

  Widget _buildErrorWidget(
    String errorMessage,
    Function() onRetryClicked, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: onRetryClicked,
                  child: Text(
                    AppLocalizations.of(context)!.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
