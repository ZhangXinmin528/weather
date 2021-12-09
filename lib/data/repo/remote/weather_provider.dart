import 'dart:async';

import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/local/sqlite_manager.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherProvider {
  final WeatherRemoteRepo _weatherRemoteRepo = WeatherRemoteRepo();
  final SqliteManager _sqliteManager = SqliteManager.INSTANCE;

  final StreamController<Map<String, dynamic>> weatherController =
      StreamController();

  final StreamController<WeatherStatus> weatherStatusController =
      StreamController();

  CityElement? _cityElement;
  bool _hasCached = false;

  void initState(CityElement cityElement) {
    this._cityElement = cityElement;
    loadCacheWeather();
  }

  void loadCacheWeather() async {
    if (_cityElement != null) {
      weatherStatusController.add(WeatherStatus.STATUS_INIT);
      final String key = _cityElement!.key;
      LogUtil.d("WeatherProvider..loadCacheWeather:${_cityElement?.city}");
      //加载缓存的天气数据
      final Map? result = await _sqliteManager.queryCityWeather(key);
      if (result != null) {
        final timeStamp = result[SqliteManager.timeStampKey];
        final span = DateTimeUtils.getTimeSpanByNow(timeStamp);
        _hasCached = true;

        // LogUtil.d("WeatherProvider..loadCacheWeather()..缓存时间间隔:$span~");

        final WeatherRT weatherNow = WeatherRT.fromJson(
            result[SqliteManager.weatherRTKey] as Map<String, dynamic>);

        final WeatherAir weatherAir = WeatherAir.fromJson(
            result[SqliteManager.weatherAirKey] as Map<String, dynamic>);

        final WeatherHour weatherHour = WeatherHour.fromJson(
            result[SqliteManager.weatherHourKey] as Map<String, dynamic>);

        final WeatherDaily weatherDaily = WeatherDaily.fromJson(
            result[SqliteManager.weatherDailyKey] as Map<String, dynamic>);

        final WeatherIndices weatherIndices = WeatherIndices.fromJson(
            result[SqliteManager.weatherIndicesKey] as Map<String, dynamic>);

        if (span > 5) {
          ///缓存过时了，请求网络
          Future.delayed(Duration(milliseconds: 500), () {
            weatherStatusController.add(WeatherStatus.STATUS_CACHED_INVALID);
          })
            ..timeout(Duration(milliseconds: 500), onTimeout: () {
              weatherStatusController.add(WeatherStatus.STATUS_REFRESHING);
            })
            ..timeout(Duration(milliseconds: 1000), onTimeout: () {
              requestWeatherData();
            });
        }

        if (weatherNow != null && weatherNow.code == "200") {
          weatherStatusController.add(WeatherStatus.STATUS_FINISHED);
          updateWeather(
              weatherRT: weatherNow,
              weatherAir: weatherAir,
              weatherHour: weatherHour,
              weatherDaily: weatherDaily,
              weatherIndices: weatherIndices);
          Future.delayed(Duration(milliseconds: 800), () {
            weatherStatusController.add(WeatherStatus.STATUS_INIT);
          });
        }
      } else {
        _hasCached = false;
        onRefresh();
      }
    }
  }

  void requestWeatherData() async {
    if (_cityElement == null) return;

    final String key = _cityElement!.key;
    final latitude = _cityElement!.latitude;
    final longitude = _cityElement!.longitude;
    LogUtil.d("WeatherProvider..requestWeatherData:$key");
    //获取天气信息

    final WeatherRT? weatherNow =
        await _weatherRemoteRepo.requestWeatherNow(longitude, latitude);

    //实时空气质量
    final WeatherAir? weatherAir =
        await _weatherRemoteRepo.requestAirNow(longitude, latitude);

    //24H
    final WeatherHour? weatherHour =
        await _weatherRemoteRepo.requestWeather24H(longitude, latitude);

    //7D
    final WeatherDaily? weatherDaily =
        await _weatherRemoteRepo.requestWeather7D(longitude, latitude);

    //当天天气指数
    final WeatherIndices? weatherIndices =
        await _weatherRemoteRepo.requestIndices1D(longitude, latitude);

    if (weatherNow != null && weatherNow.code == "200") {
      if (_hasCached) {
        final index = await _sqliteManager.updateCityWeather(key, weatherNow,
            weatherAir!, weatherHour!, weatherDaily!, weatherIndices!);
        LogUtil.d("天气tab页面..更新数据库:$index");
      } else {
        final index = await _sqliteManager.insertCityWeather(key, weatherNow,
            weatherAir!, weatherHour!, weatherDaily!, weatherIndices!);
        LogUtil.d("天气tab页面..插入数据库:$index");
      }
      weatherStatusController.add(WeatherStatus.STATUS_FINISHED);
      updateWeather(
          weatherRT: weatherNow,
          weatherAir: weatherAir,
          weatherHour: weatherHour,
          weatherDaily: weatherDaily,
          weatherIndices: weatherIndices);
      Future.delayed(Duration(milliseconds: 800), () {
        weatherStatusController.add(WeatherStatus.STATUS_INIT);
      });
    }
  }

  void onRefresh() {
    weatherStatusController.add(WeatherStatus.STATUS_REFRESHING);
    Future.delayed(Duration(milliseconds: 1000), () {
      requestWeatherData();
    });
  }

  void updateWeather(
      {required WeatherRT weatherRT,
      required WeatherAir weatherAir,
      required WeatherHour weatherHour,
      required WeatherDaily weatherDaily,
      required WeatherIndices weatherIndices}) {
    final Map<String, dynamic> weatherMap = Map();
    weatherMap['weatherRT'] = weatherRT;
    weatherMap['weatherAir'] = weatherAir;
    weatherMap['weatherHour'] = weatherHour;
    weatherMap['weatherDaily'] = weatherDaily;
    weatherMap['weatherIndices'] = weatherIndices;

    if (!weatherController.isClosed) {
      weatherController.add(weatherMap);
    }
  }

  void dispose() {
    weatherController.close();
    weatherStatusController.close();
  }
}

enum WeatherStatus {
  STATUS_INIT,
  STATUS_REFRESHING,
  STATUS_CACHED_INVALID,
  STATUS_FINISHED,
}
