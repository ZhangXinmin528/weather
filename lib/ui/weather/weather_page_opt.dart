import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/remote/weather_provider.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/ui/webview/webview_page.dart';
import 'package:weather/ui/widget/weather/weather_view.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/icon_utils.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/weather_utils.dart';

class WeatherPageOpt extends StatefulWidget {
  final CityElement _cityElement;

  WeatherPageOpt(this._cityElement);

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageOptState(_cityElement);
  }
}

class _WeatherPageOptState extends State<WeatherPageOpt>
    with AutomaticKeepAliveClientMixin {
  final WeatherProvider _weatherProvider = WeatherProvider();
  final CityElement _cityElement;

  _WeatherPageOptState(this._cityElement);

  @override
  void initState() {
    super.initState();
    LogUtil.d("WeatherPageOpt..initState");
    _weatherProvider.initState(_cityElement);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _weatherProvider.weatherController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Map<String, dynamic> weatherMap =
                snapshot.data as Map<String, dynamic>;
            return _buildWeatherNowWidget(weatherMap);
          } else {
            return SizedBox();
          }
        });
  }

  /// 展示天气实时数据
  Widget _buildWeatherNowWidget(Map<String, dynamic> weatherMap) {
    final WeatherRT weatherRT = weatherMap['weatherRT'];
    final WeatherAir weatherAir = weatherMap['weatherAir'];
    final WeatherIndices weatherIndices = weatherMap["weatherIndices"];
    final WeatherDaily weatherDaily = weatherMap['weatherDaily'];
    final WeatherHour weatherHour = weatherMap['weatherHour'];

    final weatherNow = weatherRT.now;

    final temp = weatherNow.temp + "°";

    return RefreshIndicator(
      onRefresh: () async {
        _weatherProvider.onRefresh();
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
                // _buildLightBackground(viewportConstrants.maxHeight),

                WeatherView(
                  type: weatherNow.text,
                  child: SizedBox(),
                  color: _getAppBarColor(type: weatherNow.text),
                ),
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

  /// 获取Appbar的颜色
  Color _getAppBarColor({required String type}) {
    final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;

    if (type.contains("晴") || type.contains("多云")) {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    } else if (type.contains("雨")) {
      if (type.contains("雪")) {
        return const Color(0XFF5697D8);
      } else {
        return const Color(0xFF7187DB);
      }
    } else if (type.contains("雪")) {
      return const Color(0xFF62B1FF);
    } else if (type.contains("冰雹")) {
      return const Color(0xFF0CB399);
    } else if (type.contains("霾")) {
      return const Color(0xFF7F8195);
    } else if (type.contains("沙") || type.contains("尘")) {
      return const Color(0xFFE99E3C);
    } else if (type.contains("雾")) {
      return const Color(0xFF8CADD3);
    } else if (type.contains("阴")) {
      return const Color(0xFF6D8DB1);
    } else {
      return isDay ? const Color(0xFF51C0F8) : const Color(0xFF7F9EE9);
    }
  }

  ///Time
  Widget _buildUpdateTimeWidget() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(right: 16.0, top: 50.0),
      child: Text(
        DateTimeUtils.formatNowTime() + "更新",
        key: const Key("main_screen_update_time"),
        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade200),
      ),
    );
  }

  ///temp
  Widget _buildTempWidget(String temp) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(left: 16.0, top: 80.0),
      child: Text(
        temp,
        key: const Key("main_screen_temp_now"),
        style: TextStyle(fontSize: 100, fontWeight: FontWeight.normal),
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
        top: 20,
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      margin: EdgeInsets.only(top: 20.0, left: 16.0),
      child: TextButton(
        onPressed: () {
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
                  color: WeatherUtils.getAQIColorByAqi(weatherAirNow.aqi),
                  fontSize: 20.0,
                ),
                children: <TextSpan>[
                  TextSpan(text: "\u3000"),
                  TextSpan(
                    text: weatherAirNow.aqi,
                    style: TextStyle(
                      color: WeatherUtils.getAQIColorByAqi(weatherAirNow.aqi),
                      fontSize: 20.0,
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
      margin: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
      color: Colors.white38,
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
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
      color: Colors.white,
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
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
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
      color: Colors.white,
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
      color: Colors.white,
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

  ///创建浅色背景
  Widget _buildLightBackground([double? maxHeight]) {
    return Container(
      key: const Key("main_screen_light_background"),
      child: Image.network(
        "https://cdn.qweather.com/img/plugin/190516/bg/h5/lightd.png",
        errorBuilder:
            (BuildContext context, Object exceptio, StackTrace? stackTrace) {
          LogUtil.e("An error occured when loading lightBackground image~");
          return Image.asset("images/lightd.webp");
        },
      ),
      alignment: Alignment.topCenter,
      height: maxHeight,
    );
  }

  @override
  void dispose() {
    _weatherProvider.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
