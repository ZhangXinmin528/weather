import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/bloc/app/app_bloc.dart';
import 'package:weather/bloc/app/app_event.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/bloc/main/main_page_state.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/overflow_menu_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/ui/webview/webview_page.dart';
import 'package:weather/ui/widget/application_colors.dart';
import 'package:weather/ui/widget/loading_widget.dart';
import 'package:weather/ui/widget/widget_helper.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/icon_utils.dart';
import 'package:weather/utils/log_utils.dart';

///天气主页
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  late AppBloc _appBloc;
  late MainScreenBloc _mainScreenBloc;
  late NavigationBloc _navigationBloc;
  late ScrollController _controller;

  var cityAlpha = 0.0;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of(context);
    _appBloc.add(LoadSettingsAppEvent());

    _mainScreenBloc = BlocProvider.of(context);
    //开始定位
    _mainScreenBloc.add(StartLocationEvent());

    _navigationBloc = BlocProvider.of(context);

    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 90) {
          cityAlpha = 1.0;
        } else {
          cityAlpha = _controller.offset / 90.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                ] else if (state is SuccessLoadMainScreenState) ...[
                  _buildWeatherNowWidget(state),
                  _buildToolbar(state.location),
                ] else ...[
                  _buildLightBackground(),
                  if (state is FailedLoadMainScreenState)
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
  Widget _buildWeatherNowWidget(SuccessLoadMainScreenState state) {
    final WeatherRT weatherRT = state.weather;
    final WeatherAir weatherAir = state.weatherAir;
    final WeatherIndices weatherIndices = state.weatherIndices;
    final WeatherDaily weatherDaily = state.weatherDaily;
    final WeatherHour weatherHour = state.weatherHour;
    final BaiduLocation location = state.location;

    final weatherNow = weatherRT.now;

    final String address = "${location.city} ${location.district}";
    final temp = weatherNow.temp + "°";

    return RefreshIndicator(
      onRefresh: () async {
        _mainScreenBloc.add(RefreshMainEvent());
      },
      child: LayoutBuilder(builder: (context, viewportConstrants) {
        return SingleChildScrollView(
          controller: _controller,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstrants.maxHeight),
            child: Stack(
              children: [
                _buildLightBackground(viewportConstrants.maxHeight),
                Column(
                  children: [
                    _buildCityWidget(address),
                    _buildTempWidget(temp),
                    _buildWeatherDescAndIcon(weatherRT),
                    _buildWeatherAir(weatherAir),
                    _buildUpdateTimeWidget(),
                    _buildOtherWeatherWidget(weatherRT),
                    _buildWeatherHour(weatherHour),
                    _buildWeather7Day(weatherDaily),
                    _buildWindDesc(weatherRT),
                    _buildIndicesWidget(weatherIndices),
                    _buildWeatherFooter(),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  ///Title
  Widget _buildCityWidget(String address) {
    return Opacity(
      opacity: 1 - cityAlpha,
      child: SafeArea(
        key: const Key("main_screen_city_desc"),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              key: const Key("main_screen_text_address"),
              padding: EdgeInsets.only(top: 70.0),
              child: Text(
                //定位地址
                address,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(cardColor: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  top: 70.0,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Time
  Widget _buildUpdateTimeWidget() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(right: 16.0, top: 4.0),
      child: Text(
        DateTimeUtils.formatNowTime() + "更新",
        key: const Key("main_screen_update_time"),
        style: TextStyle(fontSize: 14.0, color: Colors.grey.shade200),
      ),
    );
  }

  ///temp
  Widget _buildTempWidget(String temp) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(left: 16.0, top: 55.0),
      child: Text(
        temp,
        key: const Key("main_screen_temp_now"),
        style: TextStyle(fontSize: 60, fontWeight: FontWeight.normal),
      ),
    );
  }

  ///weather icon and desc
  Widget _buildWeatherDescAndIcon(WeatherRT weather) {
    final weatherNow = weather.now;
    return Container(
      key: const Key("main_screen_desc_and_icon"),
      margin: EdgeInsets.only(
        left: 16.0,
        top: 6,
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconUtils.getWeatherNowIcon(weatherNow.icon),
          Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Text(
              weatherNow.text,
              key: const Key("main_screen_weathernow_text"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  /// weather air
  Widget _buildWeatherAir(WeatherAir weatherAir) {
    final weatherAirNow = weatherAir.now;

    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(primary: Colors.white30);

    return Container(
      alignment: Alignment.center,
      key: const Key("main_screen_aqi_now"),
      margin: EdgeInsets.only(top: 10.0, left: 16.0),
      child: TextButton(
        onPressed: () {
          //TODO:空气质量页面
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
    );
  }

  ///other weather
  Widget _buildOtherWeatherWidget(WeatherRT weather) {
    final weatherNow = weather.now;
    return Container(
      key: const Key("main_screen_other_weather"),
      margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
                  left: 16.0,
                ),
                child: Text(
                  "降水",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0, left: 12.0),
                child: Text(
                  weatherNow.precip + "mm",
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  weatherNow.humidity + "%",
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  weatherNow.windScale + "级",
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0, right: 12.0),
                child: Text(
                  "气压",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0, right: 12.0),
                child: Text(
                  weatherNow.pressure + "hpa",
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  ///24Hour weather
  Widget _buildWeatherHour(WeatherHour weatherHour) {
    return Container(
      child: Column(
        children: [
          Divider(
            color: AppColor.line,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: const Text(
              "24小时预报",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
          Divider(
            color: AppColor.line,
          ),
          Container(
            height: 120,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weatherHour.hourly.length,
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final hour = weatherHour.hourly[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8.0),
                        child: Text(
                          DateTimeUtils.formatUTCDateTimeString(
                              hour.fxTime, DateTimeUtils.weatherHourFormat),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Text(
                        hour.temp + "°",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      IconUtils.getWeatherNowIcon(hour.icon, size: 25),
                      Text(
                        hour.windScale + "级",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  /// weather indices
  Widget _buildIndicesWidget(WeatherIndices weatherIndices) {
    final indicesDaily = weatherIndices.daily;

    return Container(
      child: Column(
        children: [
          Divider(
            color: AppColor.line,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: const Text(
              "生活指数",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
          Divider(
            color: AppColor.line,
          ),
          Container(
            key: const Key("main_screen_indicies_container"),
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 0.5,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final daily = indicesDaily[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              daily.name,
                            ),
                            titleTextStyle:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            content: Text(
                              daily.text,
                            ),
                            contentTextStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.black12,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey,
                      //       spreadRadius: 1,
                      //       blurRadius: 1.0,
                      //       offset: Offset(1.0, 1.0))
                      // ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daily.name,
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          daily.category,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: indicesDaily.length,
            ),
          ),
        ],
      ),
    );
  }

  ///weather 7Day
  Widget _buildWeather7Day(WeatherDaily weatherDaily) {
    return Container(
      child: Column(
        children: [
          Divider(
            color: AppColor.line,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: const Text(
              "七天预报",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
          Divider(
            color: AppColor.line,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (conteext, index) {
                final daily = weatherDaily.daily[index];

                final date = DateTimeUtils.formatDateTimeString(
                    daily.fxDate, DateTimeUtils.dailyFormat);

                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 12.0, top: 8.0, right: 12.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_icon"),
                        padding: EdgeInsets.only(left: 10),
                        child: IconUtils.getWeatherNowIcon(daily.iconDay,
                            size: 25),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_tempmax"),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          daily.tempMax,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.purpleAccent,
                              Colors.purple,
                              Colors.deepPurple,
                            ]),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_tempmin"),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          daily.tempMin,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_night_icon"),
                        padding: EdgeInsets.only(left: 10),
                        child: IconUtils.getWeatherNowIcon(daily.iconNight,
                            size: 25),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
              },
              itemCount: weatherDaily.daily.length),
        ],
      ),
    );
  }

  ///wind
  Widget _buildWindDesc(WeatherRT weatherRT) {
    final now = weatherRT.now;
    return Container(
      key: const Key("main_screen_wind_desc"),
      child: Column(
        children: [
          Divider(
            color: AppColor.line,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: const Text(
              "风力风向",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
          Divider(
            color: AppColor.line,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LottieBuilder.asset(
                'assets/lottiefiles/windmillpath.json',
                width: 150.0,
                height: 200.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '风力',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windScale}级',
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: const Text(
                      '风向',
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windDir}',
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: const Text(
                      '风速',
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windSpeed}公里/小时',
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunAndMoon() {
    return Container(
      child: Column(
        children: [
          Divider(
            color: AppColor.line,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: const Text(
              "太阳和月亮",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
          Divider(
            color: AppColor.line,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherFooter() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Text(
        "天气数据由和风天气提供",
        style: TextStyle(color: Colors.grey),
      ),
    );
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
        detailedDescription = appLocalizations.error_location_disabled;
        break;
      case WeatherError.data_not_available:
        detailedDescription = appLocalizations.error_date_not_available;
        break;
    }

    return _buildErrorWidget(
      "${appLocalizations.error_failed_to_load_weather_data} $detailedDescription",
      () {
        _mainScreenBloc.add(RefreshMainEvent());
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
  Widget _buildLightBackground([double? maxHeight]) {
    return Container(
      key: const Key("main_screen_light_background"),
      child: Image.network(
        "https://cdn.qweather.com/img/plugin/190516/bg/h5/lightd.png",
        errorBuilder:
            (BuildContext context, Object exceptio, StackTrace? stackTrace) {
          LogUtil.e("An error occured when loading lightBackground image~");
          return Image.asset("images/lightd.png");
        },
      ),
      alignment: Alignment.topCenter,
      height: maxHeight,
    );
  }

  ///创建深色背景
  Widget _buildDarkBackground() {
    return Container(
      key: const Key("main_screen_dark_background"),
      child: Image.network(
          "https://cdn.qweather.com/img/plugin/190516/bg/h5/darkd.png"),
    );
  }

  ///随天气变化背景
  Widget _buildWeatherChangedBg(SuccessLoadMainScreenState state) {
    final hour = DateTime.now().hour;
    var icon = state.weather.now.icon;
    String bgSufix = "";
    //当icon ==154时 获取不到对应的背景图片
    if (icon == "154") icon = "104";
    if (6 < hour && hour < 20)
      bgSufix = "$icon" + "d.png";
    else
      bgSufix = "$icon" + "n.png";
    final String url =
        "https://cdn.qweather.com/img/plugin/190516/bg/h5/" + bgSufix;
    return Container(
      key: const Key("main_screen_weather_changed_background"),
      child: Image.network(
        url,
        fit: BoxFit.fill,
      ),
    );
  }

  ///异常情况
  Widget _buildErrorWidget(
    String errorMessage,
    Function() onRetryClicked, {
    Key? key,
  }) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(primary: Colors.redAccent);

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
                  style: const TextStyle(color: Colors.red),
                ),
                TextButton(
                  onPressed: onRetryClicked,
                  child: Text(
                    AppLocalizations.of(context)!.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: buttonStyle,
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
    final String address = "${location.city} ${location.district}";

    return Container(
      key: const Key("main_screen_toolbar"),
      color: Color.fromARGB(150, 149, 182, 226),
      padding: EdgeInsets.only(top: 40.0),
      child: Stack(
        children: [
          Opacity(
            opacity: cityAlpha,
            child: Row(
              key: Key('main_screen_toolbar_title'),
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  //定位地址
                  address,
                  key: const Key("main_screen_text_address"),
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
                ),
                Theme(
                  data: Theme.of(context).copyWith(cardColor: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            key: Key('main_screen_toolbar_menu'),
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
          Row(
            key: Key('main_screen_toolbar_city'),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context).copyWith(cardColor: Colors.white),
                child: IconButton(
                    onPressed: () {
                      _navigationBloc.add(CityManagePageNavigationEvent());
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            ],
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

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsPageNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }
}
