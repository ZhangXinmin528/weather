import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/navigation/navigation_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/data/repo/remote/weather_provider.dart';
import 'package:weather/resources/config/colors.dart';
import 'package:weather/ui/webview/webview_page_nobar.dart';
import 'package:weather/ui/widget/loading_widget_line_text.dart';
import 'package:weather/ui/widget/weather/weather_view.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/icon_utils.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/system_util.dart';
import 'package:weather/utils/weather_utils.dart';

class WeatherPageOpt extends StatefulWidget {
  final CityElement _cityElement;
  final int _position;

  WeatherPageOpt(this._cityElement, this._position);

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageOptState(_cityElement, _position);
  }
}

class _WeatherPageOptState extends State<WeatherPageOpt>
    with AutomaticKeepAliveClientMixin {
  final WeatherProvider _weatherProvider = WeatherProvider();
  late MainPageBloc _mainPageBloc;
  late NavigationBloc _navigationBloc;
  final CityElement _cityElement;
  final int _position;
  late bool _location;

  Color? weatherColor;

  double _devicePixelRatio = 0;

  _WeatherPageOptState(this._cityElement, this._position);

  @override
  void initState() {
    super.initState();
    weatherColor = Colors.white38;
    _location = _position == 0;
    LogUtil.d("WeatherPageOpt..initState");
    _mainPageBloc = BlocProvider.of(context);
    _navigationBloc = BlocProvider.of(context);
    _weatherProvider.initState(_mainPageBloc, _cityElement);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _devicePixelRatio = getScreenPixelRatio(context);
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
    final WeatherWarning? weatherWarning = weatherMap['weatherWarning'];

    final weatherNow = weatherRT.now;
    weatherColor = _getWeatherThemeColor(type: weatherNow.text);

    return RefreshIndicator(
      onRefresh: () async {
        _weatherProvider.onRefresh(_location);
      },
      displacement: 70,
      edgeOffset: 30,
      child: LayoutBuilder(builder: (context, viewportConstrants) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstrants.maxHeight),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    WeatherView(
                      type: weatherNow.text,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            _buildStatusOrTimeWidget(weatherRT),
                            SizedBox(
                              height: _devicePixelRatio == 0
                                  ? 50
                                  : 18.2 * _devicePixelRatio,
                            ),
                            _buildWeatherDesc(weatherRT, weatherAir),
                            _buildWarningWidget(weatherWarning),
                          ],
                        ),
                      ),
                      color: weatherColor!,
                    ),
                    Visibility(
                      visible: _location,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WeatherMapPage(
                                "https://map.qweather.com/index.html");
                          }));
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
                          child: Image.asset(
                            "images/icon_map.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildWeatherHour(weatherHour),
                _buildWeather7Day(weatherDaily),
                _buildWindDesc(weatherRT),
                _buildIndicesWidget(weatherIndices),
                _buildWeatherFooter(),
              ],
            ),
          ),
        );
      }),
    );
  }

  ///天气主题色
  Color _getWeatherThemeColor({required String type}) {
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

  ///weather warning widget
  Widget _buildWarningWidget([WeatherWarning? weatherWarning]) {
    final warningList = weatherWarning?.warning;

    if (warningList == null || warningList.isEmpty) {
      return SizedBox(
        height: 35,
      );
    }
    return Container(
      height: 35,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: AppColor.blackGround,
      ),
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      alignment: Alignment.centerLeft,
      child: PageView.builder(
        itemBuilder: (context, index) {
          final Warning? warning = warningList[index];
          return GestureDetector(
            onTap: () {
              _navigationBloc.add(WarningNavigationEvent(warningList));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconUtils.getWeatherWarningSVGIcon(warning?.type,
                    color:
                        IconUtils.getWeatherWarningLevelColor(warning?.level),
                    size: 20),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${warning?.typeName}${warning?.level}预警",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: warningList.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  ///Time_buildUpdateTimeWidget
  Widget _buildStatusOrTimeWidget(WeatherRT weatherRT) {
    final top = _devicePixelRatio == 0
        ? 40 + getAppBarHeight()
        : 14.6 * _devicePixelRatio + getAppBarHeight();
    return Container(
      margin: EdgeInsets.only(top: top),
      height: 20,
      child: StreamBuilder(
        stream: _weatherProvider.weatherStatusController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final WeatherStatus status = snapshot.data as WeatherStatus;

            if (status == WeatherStatus.STATUS_REFRESHING) {
              return LoadingLineWidget("正在刷新数据...");
            } else if (status == WeatherStatus.STATUS_CACHED_INVALID) {
              return Text(
                "天气数据已过期",
                style: TextStyle(color: AppColor.textWhite, fontSize: 12.0),
              );
            } else if (status == WeatherStatus.STATUS_FINISHED) {
              return Text(
                "数据加载完成",
                style: TextStyle(color: AppColor.textWhite, fontSize: 12.0),
              );
            } else {
              return Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 16.0),
                child: Text(
                  "更新于：${DateTimeUtils.formatUTCDateTimeString(weatherRT.updateTime, DateTimeUtils.weatherTimeFormat)}",
                  key: const Key("main_screen_update_time"),
                  style: TextStyle(fontSize: 14.0, color: AppColor.textWhite60),
                ),
              );
            }
          } else {
            return Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 16.0),
              child: Text(
                "更新于：${DateTimeUtils.formatUTCDateTimeString(weatherRT.updateTime, DateTimeUtils.weatherTimeFormat)}",
                key: const Key("main_screen_update_time"),
                style: TextStyle(fontSize: 14.0, color: AppColor.textWhite60),
              ),
            );
          }
        },
      ),
    );
  }

  ///weather now desc
  Widget _buildWeatherDesc(WeatherRT weather, WeatherAir weatherAir) {
    final weatherNow = weather.now;
    final temp = weatherNow.temp + "°";
    final airNow = weatherAir.now;

    return Container(
      key: const Key("main_screen_desc_and_icon"),
      margin: EdgeInsets.only(
        top: 20,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                temp,
                key: const Key("main_screen_temp_now"),
                style: TextStyle(fontSize: 100, fontWeight: FontWeight.normal),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      weatherNow.text,
                      key: const Key("main_screen_weathernow_text"),
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                        color: WeatherUtils.getAQIColorByAqi(airNow.aqi)
                            .withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        shape: BoxShape.rectangle),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, top: 4, right: 10, bottom: 4),
                      child: Text(
                        WeatherUtils.getAQIDesc(airNow),
                        key: const Key("main_screen_weathernow_text"),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 4.0),
                    child: Text(
                      "湿度",
                      style: TextStyle(
                          fontSize: 16.0, color: AppColor.textWhite60),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 2.0, right: 8.0),
                    child: Text(
                      weatherNow.humidity + "%",
                      style: TextStyle(
                          fontSize: 16.0, color: AppColor.textWhite60),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 4.0),
                    child: Text(
                      weatherNow.windDir,
                      style: TextStyle(
                          fontSize: 16.0, color: AppColor.textWhite60),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 2.0, right: 8.0),
                    child: Text(
                      weatherNow.windScale + "级",
                      style: TextStyle(
                          fontSize: 16.0, color: AppColor.textWhite60),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  ///24Hour weather
  Widget _buildWeatherHour(WeatherHour weatherHour) {
    return Container(
      height: 120,
      color: AppColor.ground,
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                  padding: EdgeInsets.only(left: 16, top: 12.0, right: 16),
                  child: Text(
                    hour.temp + "°",
                    style: TextStyle(
                        color: index == 0
                            ? AppColor.textGreyLight
                            : AppColor.textBlack,
                        fontSize: 16),
                  ),
                ),
                IconUtils.getWeatherSVGIcon(hour.icon, size: 25),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 4.0, right: 16, bottom: 4),
                  child: Text(
                    hour.text,
                    style: TextStyle(
                        color: index == 0
                            ? AppColor.textGreyLight
                            : AppColor.textBlack,
                        fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 12.0),
                  child: Text(
                    DateTimeUtils.formatUTCDateTimeString(
                        hour.fxTime, DateTimeUtils.weatherHourFormat),
                    style: TextStyle(
                      color: index == 0
                          ? AppColor.textGreyLight
                          : AppColor.textBlack,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  /// weather indices
  Widget _buildIndicesWidget(WeatherIndices weatherIndices) {
    final indicesDaily = weatherIndices.daily;

    return Card(
      key: const Key("main_screen_weather_indices"),
      color: AppColor.ground,
      margin: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0, bottom: 12.0),
      elevation: 0.5,
      shadowColor: AppColor.shadow,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: const Text(
              "生活指数",
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.textBlack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            key: const Key("main_screen_indicies_container"),
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                            titleTextStyle: TextStyle(
                                fontSize: 18.0, color: AppColor.textBlack),
                            content: Text(
                              daily.text,
                            ),
                            contentTextStyle: TextStyle(
                                fontSize: 14.0, color: AppColor.textGreyLight),
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
                      border: Border.all(color: AppColor.line3, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daily.name,
                          style: TextStyle(
                              fontSize: 14.0, color: AppColor.textGreyLight),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          daily.category,
                          style: TextStyle(
                              fontSize: 16.0, color: AppColor.textBlack),
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
    return Card(
      color: AppColor.ground,
      margin: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
      elevation: 0.5,
      shadowColor: AppColor.shadow,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: const Text(
              "七天预报",
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.textBlack,
                  fontWeight: FontWeight.bold),
            ),
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
                        style: TextStyle(color: AppColor.textGreyLight),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_icon"),
                        padding: EdgeInsets.only(left: 10),
                        child: IconUtils.getWeatherSVGIcon(daily.iconDay,
                            size: 25),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_text"),
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          daily.textDay,
                          style: TextStyle(color: AppColor.textBlack),
                        ),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_tempmax"),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          daily.tempMax,
                          style: TextStyle(color: AppColor.textBlack),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 4,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.redAccent,
                              Colors.orange,
                              Colors.lightBlueAccent,
                            ]),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_daily_tempmin"),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          daily.tempMin,
                          style: TextStyle(color: AppColor.textBlack),
                        ),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_night_icon"),
                        padding: EdgeInsets.only(left: 10),
                        child: IconUtils.getWeatherSVGIcon(daily.iconNight,
                            size: 25),
                      ),
                      Padding(
                        key: const Key("main_screen_7d_night_text"),
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          daily.textNight,
                          style: TextStyle(color: AppColor.textBlack),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                  color: AppColor.line3,
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
    return Card(
      key: const Key("main_screen_wind_desc"),
      color: AppColor.ground,
      margin: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
      elevation: 0.5,
      shadowColor: AppColor.shadow,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 4.0),
            child: const Text(
              "风力风向",
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.textBlack,
                  fontWeight: FontWeight.bold),
            ),
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
                    style: TextStyle(
                        color: AppColor.textGreyLight, fontSize: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windScale}级',
                      style:
                          TextStyle(color: AppColor.textBlack, fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: const Text(
                      '风向',
                      style: TextStyle(
                          color: AppColor.textGreyLight, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windDir}',
                      style:
                          TextStyle(color: AppColor.textBlack, fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: const Text(
                      '风速',
                      style: TextStyle(
                          color: AppColor.textGreyLight, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${now.windSpeed}公里/小时',
                      style:
                          TextStyle(color: AppColor.textBlack, fontSize: 14.0),
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
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      color: AppColor.ground,
      child: Text(
        "天气数据由和风天气提供",
        style: TextStyle(color: AppColor.textGreyLight),
      ),
    );
  }

  @override
  void dispose() {
    _weatherProvider.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
