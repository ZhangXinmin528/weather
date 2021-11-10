import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/weather/weather_page_bloc.dart';
import 'package:weather/bloc/weather/weather_page_event.dart';
import 'package:weather/bloc/weather/weather_page_state.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/ui/webview/webview_page.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/icon_utils.dart';
import 'package:weather/utils/log_utils.dart';

///各个城市天气主页
class WeatherPage extends StatefulWidget {
  final CityElement _cityElement;

  WeatherPage(this._cityElement, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState(_cityElement);
  }
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherPageBloc _weatherPageBloc;
  late NavigationBloc _navigationBloc;
  final CityElement _cityElement;

  _WeatherPageState(this._cityElement);

  @override
  void initState() {
    super.initState();
    LogUtil.d("WeatherPage..initState()..city:${_cityElement.name}~");
    _weatherPageBloc = BlocProvider.of(context);
    //开始请求天气
    _weatherPageBloc.add(LoadCachedWeatherEvent(_cityElement));
    _weatherPageBloc.emit(LoadCachedWeatherDataState());

    _navigationBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherPageBloc, WeatherPageState>(
        builder: (context, state) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          if (state is StartReuestWeatherState) ...[
            // _buildLightBackground(),
            //开始定位
            // const LoadingWidget(),
          ] else if (state is RequestWeatherSuccessState) ...[
            _buildWeatherNowWidget(state),
          ] else ...[
            if (state is RequestWeatherFailedState)
              _buildFailedToLoadDataWidget(state.error)
            else
              const SizedBox()
          ],
        ],
      );
    });
  }

  /// 展示天气实时数据
  Widget _buildWeatherNowWidget(RequestWeatherSuccessState state) {
    LogUtil.d(
        "WeatherPage.._buildWeatherNowWidget()..city:${_cityElement.name}~");
    final WeatherRT weatherRT = state.weather;
    final WeatherAir weatherAir = state.weatherAir;
    final WeatherIndices weatherIndices = state.weatherIndices;
    final WeatherDaily weatherDaily = state.weatherDaily;
    final WeatherHour weatherHour = state.weatherHour;

    final weatherNow = weatherRT.now;

    final temp = weatherNow.temp + "°";

    return RefreshIndicator(
      onRefresh: () async {
        // _weatherPageBloc.add(RefreshMainEvent());
      },
      displacement: 70,
      edgeOffset: 30,
      child: LayoutBuilder(builder: (context, viewportConstrants) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstrants.maxHeight),
            child: Stack(
              children: [
                _buildLightBackground(viewportConstrants.maxHeight),
                Column(
                  children: [
                    const SizedBox(
                      height: 120.0,
                    ),
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

  ///Time
  Widget _buildUpdateTimeWidget() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(right: 16.0, top: 10.0),
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
      margin: EdgeInsets.only(left: 16.0, top: 60.0),
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
              padding: EdgeInsets.all(4),
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
              padding: EdgeInsets.only(top: 0.0),
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
        // _weatherPageBloc.add(RefreshMainEvent());
      },
      key: const Key("main_screen_failed_to_load_data_widget"),
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
  Widget _buildWeatherChangedBg(RequestWeatherSuccessState state) {
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
}
