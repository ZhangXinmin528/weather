import 'dart:async';

import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_page_bloc.dart';
import 'package:weather/bloc/main/main_page_event.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/local/sqlite_manager.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherProvider {
  //接口数据
  final WeatherRemoteRepo _weatherRemoteRepo = WeatherRemoteRepo();
  final SqliteManager _sqliteManager = SqliteManager.INSTANCE;

  //location
  final LocationManager _locationManager = LocationManager();
  BaiduLocation? _baiduLocation;

  MainPageBloc? _mainPageBloc;

  //天气数据
  final StreamController<Map<String, dynamic>> weatherController =
      StreamController();

  //页面状态
  final StreamController<WeatherStatus> weatherStatusController =
      StreamController();

  final StreamController<BaiduLocation> locationController = StreamController();

  CityElement? _cityElement;
  bool _hasCached = false;

  void initState(MainPageBloc bloc, CityElement cityElement) {
    _mainPageBloc = bloc;
    this._cityElement = cityElement;
    _initLocationCallback();
    _loadCacheWeather();
  }

  ///还需要处理
  void _initLocationCallback() {
    _locationManager.listenLocationCallback((value) {
      //定位变化

      LogUtil.d("WeatherProvider..定位回调了..city：${value?.city}");
      if (value != null && value.city!.isNotEmpty) {
        _baiduLocation = value;
        locationController.add(_baiduLocation!);
        Future.delayed(Duration(seconds: 1), () {
          _mainPageBloc?.add(LocationChangedEvent());
          _mainPageBloc?.baiduLocation = _baiduLocation;
          //更新天气数据
          final String key =
              "${_baiduLocation?.latitude}&${_baiduLocation?.longitude}";

          _cityElement?.key = key;
          _cityElement?.longitude = _baiduLocation!.longitude!;
          _cityElement?.latitude = _baiduLocation!.latitude!;
          _requestWeatherData();
        });
        _locationManager.stopLocation();
        _mainPageBloc?.saveLocation();
      }
    });
  }

  void _loadCacheWeather() async {
    if (_cityElement != null) {
      weatherStatusController.add(WeatherStatus.STATUS_INIT);
      final String key = _cityElement!.key;
      LogUtil.d("WeatherProvider..loadCacheWeather:${_cityElement?.name}");
      //加载缓存的天气数据
      final Map? result = await _sqliteManager.queryCityWeather(key);
      if (result != null) {
        final timeStamp = result[SqliteManager.timeStampKey];
        final span = DateTimeUtils.getTimeSpanByNow(timeStamp);
        _hasCached = true;

        LogUtil.d("WeatherProvider..loadCacheWeather()..缓存时间间隔:$span~");

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
          Future.delayed(Duration(milliseconds: 1500), () {
            weatherStatusController.add(WeatherStatus.STATUS_CACHED_INVALID);
          })
            ..timeout(Duration(milliseconds: 500), onTimeout: () {
              weatherStatusController.add(WeatherStatus.STATUS_REFRESHING);
            })
            ..timeout(Duration(milliseconds: 1000), onTimeout: () {
              _requestWeatherData();
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
        onRefresh(false);
      }
    }
  }

  void _requestWeatherData() async {
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

  void onRefresh(bool location) {
    weatherStatusController.add(WeatherStatus.STATUS_REFRESHING);
    if (location) {
      _locationManager.startLocation();
    } else {
      Future.delayed(Duration(milliseconds: 1000), () {
        _requestWeatherData();
      });
    }
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
