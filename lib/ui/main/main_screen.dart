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
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/application_error.dart';
import 'package:weather/data/model/internal/overflow_menu_element.dart';
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
    _mainScreenBloc.add(LocationChangedEvent());

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
                if (state is StartLocationState ||
                    state is LoadingMainScreenState) ...[
                  const AnimatedGradientWidget(),
                  const LoadingWidget(),
                ] else ...[
                  _buildGradientWidget(),
                  if (state is SuccessLoadMainScreenState)
                    _buildWeatherWidget(state.weatherResponse,
                        state.weatherForecastListResponse)
                  else if (state is FailedLoadMainScreenState)
                    _buildFailedToLoadDataWidget(state.error)
                  else
                    const SizedBox()
                ],
                _buildOverflowMenu()
              ],
            );
          })
        ],
      ),
    );
  }

  ///失败页面
  Widget _buildFailedToLoadDataWidget(ApplicationError error) {
    final appLocalizations = AppLocalizations.of(context)!;
    String detailedDescription = "";
    switch (error) {
      case ApplicationError.apiError:
        detailedDescription = appLocalizations.error_api;
        break;
      case ApplicationError.connectionError:
        detailedDescription = appLocalizations.error_server_connection;
        break;
      case ApplicationError.locationError:
        detailedDescription = appLocalizations.error_location_not_selected;
        break;
    }

    return _buildErrorWidget(
      "${appLocalizations.error_failed_to_load_weather_data} $detailedDescription",
      () {
        _mainScreenBloc.add(WeatherDataLoadedMainEvent());
      },
      key: const Key("main_screen_failed_to_load_data_widget"),
    );
  }

  ///天气信息主页面
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

  ///异常情况
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

  ///构建菜单
  Widget _buildOverflowMenu() {
    return SafeArea(
      key: const Key("main_screen_overflow_menu"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Theme(
            data: Theme.of(context).copyWith(cardColor: Colors.white),
            child: PopupMenuButton<PopupMenuElement>(
              onSelected: (PopupMenuElement element) {
                _onMenuElementClicked(element, context);
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) {
                return _getOverflowMenu(context)
                    .map((PopupMenuElement element) {
                  return PopupMenuItem<PopupMenuElement>(
                    value: element,
                    child: Text(
                      element.title!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_settings"),
        title: applicationLocalization.settings));
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_about"),
        title: applicationLocalization.about));
    return menuList;
  }

  ///菜单点击
  void _onMenuElementClicked(PopupMenuElement value, BuildContext context) {
    List<Color> startGradientColors = [];
    if (_mainScreenBloc.state is SuccessLoadMainScreenState) {
      final weatherResponse =
          (_mainScreenBloc.state as SuccessLoadMainScreenState).weatherResponse;
      final LinearGradient gradient = WidgetHelper.getGradient(
          sunriseTime: weatherResponse.system!.sunrise,
          sunsetTime: weatherResponse.system!.sunset);
      startGradientColors = gradient.colors;
    }

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsScreenNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }
}
