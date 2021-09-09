import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/app/app_event.dart';
import 'package:weather/bloc/main/main_screen_bloc.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/overflow_menu_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/ui/webview/webview.dart';
import 'package:weather/ui/widget/application_colors.dart';
import 'package:weather/ui/widget/loading_widget.dart';
import 'package:weather/ui/widget/widget_helper.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/icon_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  late AppBloc _appBloc;
  late MainScreenBloc _mainScreenBloc;
  late NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of(context);
    _appBloc.add(LoadSettingsAppEvent());

    _mainScreenBloc = BlocProvider.of(context);
    //开始定位
    _mainScreenBloc.add(StartLocationEvent());

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
                if (state is StartLocationState) ...[
                  //开始定位
                  _buildLightBackground(),
                  const LoadingWidget(),
                ] else ...[
                  _buildLightBackground(),
                  if (state is SuccessLoadMainScreenState)
                    _buildWeatherNowWidget(
                        state.weather, state.weatherAir, state.location)
                  else if (state is FailedLoadMainScreenState)
                    _buildFailedToLoadDataWidget(state.error)
                  else
                    const SizedBox()
                ],
              ],
            );
          })
        ],
      ),
    );
  }

  /// 展示天气实时数据
  Widget _buildWeatherNowWidget(
      WeatherRT weather, WeatherAir weatherAir, BaiduLocation location) {
    final weatherNow = weather.now;
    final weatherAirNow = weatherAir.now;

    final String address = location.city + " " + location.district;
    final temp = weatherNow.temp + "°";

    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(primary: Colors.white54);

    return LayoutBuilder(builder: (context, viewportCOnstrants) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportCOnstrants.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                //toolbar
                SafeArea(
                  key: const Key("main_screen_city_desc"),
                  child: Row(
                    children: [
                      Theme(
                        data:
                            Theme.of(context).copyWith(cardColor: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            top: 8.0,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        key: const Key("main_screen_text_address"),
                        padding: EdgeInsets.only(left: 10.0, top: 8.0),
                        child: Text(
                          //定位地址
                          address,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 50.0, top: 4.0),
                  child: Text(
                    DateTimeUtils.formatNowTime() + "更新",
                    key: const Key("main_screen_update_time"),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 16.0, top: 80.0),
                  child: Text(
                    temp,
                    key: const Key("main_screen_temp_now"),
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  key: const Key("main_screen_desc_and_icon"),
                  margin: EdgeInsets.only(
                    left: 16.0,
                    top: 6,
                  ),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconUtils.getWeatherNowIcon(weatherNow.icon),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(
                          weatherNow.text,
                          key: const Key("main_screen_weathernow_text"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  key: const Key("main_screen_aqi_now"),
                  margin: EdgeInsets.only(top: 12.0, left: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO:空气质量页面
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WebviewPage("和风天气", weatherAir.fxLink);
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: weatherAirNow.category,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "\u3000"),
                              TextSpan(
                                text: weatherAirNow.aqi,
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                    style: buttonStyle,
                  ),
                ),
                Container(
                  key: const Key("main_screen_other_weather"),
                  margin: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 40.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 16.0,
                              bottom: 8.0,
                              left: 12.0,
                            ),
                            child: Text(
                              "降水",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 16.0, left: 12.0),
                            child: Text(
                              weatherNow.precip + "mm",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                            child: Text(
                              "湿度",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                            child: Text(
                              weatherNow.humidity + "%",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                            child: Text(
                              weatherNow.windDir,
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                            child: Text(
                              weatherNow.windScale + "级",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 16.0, bottom: 8.0, right: 12.0),
                            child: Text(
                              "气压",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 16.0, right: 12.0),
                            child: Text(
                              weatherNow.pressure + "hpa",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  ///失败页面
  Widget _buildFailedToLoadDataWidget(WeatherError error) {
    final appLocalizations = AppLocalizations.of(context)!;
    String detailedDescription = "";
    switch (error) {
      case WeatherError.connectionError:
        detailedDescription = appLocalizations.error_server_connection;
        break;
      case WeatherError.locationError:
        detailedDescription = appLocalizations.error_location_not_selected;
        break;
      case WeatherError.data_not_available:
        detailedDescription = appLocalizations.error_date_not_available;
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

  ///创建浅色背景
  Widget _buildLightBackground() {
    return Container(
      key: const Key("main_screen_light_background"),
      child: Image.network(
          "https://cdn.qweather.com/img/plugin/190516/bg/h5/lightd.png"),
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

  ///构建标题栏
  Widget _buildToolbar(BaiduLocation location) {
    return SafeArea(
      key: const Key("main_screen_overflow_menu"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      // final weatherResponse =
      //     (_mainScreenBloc.state as SuccessLoadMainScreenState).weatherResponse;
      // final LinearGradient gradient = WidgetHelper.getGradient(
      //     sunriseTime: weatherResponse.system!.sunrise,
      //     sunsetTime: weatherResponse.system!.sunset);
      // startGradientColors = gradient.colors;
    }

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsScreenNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }
}
