import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/data/model/internal/application_error.dart';
import 'package:weather/data/model/internal/geo_position.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/data/repository/local/application_local_repository.dart';
import 'package:weather/data/repository/local/weather_local_repository.dart';
import 'package:weather/data/repository/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/log_utils.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final LocationManager _locationManager;
  final WeatherLocalRepository _weatherLocalRepository;
  final WeatherRemoteRepository _weatherRemoteRepository;

  final ApplicationLocalRepository _applicationLocalRepository;

  Timer? _refreshTimer;

  MainScreenBloc(this._locationManager, this._weatherLocalRepository,
      this._weatherRemoteRepository, this._applicationLocalRepository)
      : super(InitialMainScreenState());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    //定位权限 相关
    if (event is LocationCheckMainEvent) {
      yield CheckLocationMainScreenState();

      if (!await _checkLocationServiceEnabled()) {
        //无法定位
        yield LocationServiceDisableMianScreenState();
      } else {
        final permissionState = await _checkPermission();
        if (permissionState == null) {
          yield* _loadWeatherData();
        } else {
          yield permissionState;
        }
      }
    }

    if (event is LoadWeatherMainEvent) {
      yield* _loadWeatherData();
    }
  }

  ///整合定位和天气信息
  Stream<MainScreenState> _loadWeatherData() async* {
    yield LoadingMainScreenState();

    final GeoPosition? position = await _getPosition();
    LogUtil.d("Get geoPosition:$position");

    if (position != null) {
      //获取天气信息
      final WeatherResponse? weatherResponse =
          await _fetcherWeather(position.lat, position.long);

      //获取天气预测信息
      final WeatherForecastListResponse? weatherForecastListResponse =
          await _fetcherWeatherForecast(position.lat, position.long);

      if (weatherResponse != null && weatherForecastListResponse != null) {
        if (weatherResponse.errorCode != null) {
          yield FailedLoadMainScreenState(weatherResponse.errorCode!);
        } else if (weatherForecastListResponse.errorCode != null) {
          yield FailedLoadMainScreenState(
              weatherForecastListResponse.errorCode!);
        } else {
          //加载天气数据
          yield SuccessLoadMainScreenState(
              weatherResponse, weatherForecastListResponse);
        }
      } else {
        yield const FailedLoadMainScreenState(ApplicationError.connectionError);
      }
    } else {
      yield const FailedLoadMainScreenState(
          ApplicationError.locationNotSelectedError);
    }
  }

  ///获取天气预测信息
  Future<WeatherForecastListResponse?> _fetcherWeatherForecast(
      double? latitude, double? longitude) async {
    WeatherForecastListResponse weatherForecastResponse =
        await _weatherRemoteRepository.fetcherForecast(latitude, longitude);

    if (weatherForecastResponse.errorCode != null) {
      _weatherLocalRepository.saveWeatherForecast(weatherForecastResponse);
    } else {
      final WeatherForecastListResponse? cacheResponse =
          await _weatherLocalRepository.getWeatherForecast();

      if (cacheResponse != null) {
        weatherForecastResponse = cacheResponse;
      }
    }
    return weatherForecastResponse;
  }

  ///获取天气数据
  Future<WeatherResponse?> _fetcherWeather(
      double? latitude, double? longitude) async {
    LogUtil.d("Fetcher weather~");

    final WeatherResponse weatherResponse =
        await _weatherRemoteRepository.fetchWeather(latitude, longitude);

    if (weatherResponse.errorCode == null) {
      _weatherLocalRepository.saveWeather(weatherResponse);
      return weatherResponse;
    } else {
      LogUtil.d("load cache weather data~");
      final WeatherResponse? weatherCacheResponse =
          await _weatherLocalRepository.getWeather();
      if (weatherCacheResponse != null) {
        return weatherCacheResponse;
      }
    }
  }

  ///获取定位地址
  Future<GeoPosition?> _getPosition() async {
    try {
      //获取当前定位地址
      final position = await _locationManager.getLocation();
      if (position != null) {
        LogUtil.i("Position is present!");
        final GeoPosition geoPosition = GeoPosition.fromPosition(position);
        _weatherLocalRepository.saveLocation(geoPosition);
        return geoPosition;
      } else {
        //返回最近缓存地址
        LogUtil.e("Position is not present!");
        return _weatherLocalRepository.getLocation();
      }
    } catch (exception, stackTrace) {
      LogUtil.e("getPosition failed~",
          error: exception, stackTrace: stackTrace);
      return null;
    }
  }

  ///检查能否定位
  Future<bool> _checkLocationServiceEnabled() async {
    return _locationManager.isLocationEnable();
  }

  ///检查定位是否授权
  Future<PermissionNotGrantedMainScreenState?> _checkPermission() async {
    final permissionCheck = await _locationManager.checkLocationPermission();
    if (permissionCheck == LocationPermission.denied) {
      final permissionRequest =
          await _locationManager.requestLocationPermission();

      if (permissionRequest == LocationPermission.always ||
          permissionRequest == LocationPermission.whileInUse) {
        return null;
      } else {
        return PermissionNotGrantedMainScreenState(
            permissionRequest == LocationPermission.deniedForever);
      }
    } else if (permissionCheck == LocationPermission.deniedForever) {
      return const PermissionNotGrantedMainScreenState(true);
    } else {
      return null;
    }
  }
}
