import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/data/model/internal/application_error.dart';
import 'package:weather/data/model/internal/coordinate.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/data/repository/local/application_local_repository.dart';
import 'package:weather/data/repository/local/weather_local_repository.dart';
import 'package:weather/data/repository/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/log_utils.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final LocationManager _locationManager = LocationManager();
  final WeatherLocalRepository _weatherLocalRepository;
  final WeatherRemoteRepository _weatherRemoteRepository;

  final ApplicationLocalRepository _applicationLocalRepository;

  late BaiduLocation? _baiduLocation;

  Timer? _refreshTimer;

  MainScreenBloc(this._weatherLocalRepository, this._weatherRemoteRepository,
      this._applicationLocalRepository)
      : super(StartLocationState());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    LogUtil.d("mapEventToState..$event");
    //开始定位
    if (event is StartLocationEvent) {
      yield* _mapStartLocationToState(state);
    } else if (event is LocationChangedEvent) {
      yield* _mapLocationChangedToState(state);
    } else if (event is WeatherDataLoadedMainEvent) {
      //加载天气数据
      yield* _mapWeatherToState(state);
    }
  }

  ///开始定位
  Stream<MainScreenState> _mapStartLocationToState(
      MainScreenState state) async* {
    LogUtil.d("开始定位~");
    if (state is StartLocationState) {
      //请求定位权限
      _locationManager.requestLocationPermission();

      _locationManager.startLocation((value) {
        //定位变化
        _baiduLocation = value;
        add(LocationChangedEvent());
        //停止定位
        _locationManager.stopLocation();
        LogUtil.d("定位回调了~_baiduLocation：${_baiduLocation?.address}");
      });

      yield LocationChangedState();
    }
  }

  ///定位相关逻辑
  Stream<MainScreenState> _mapLocationChangedToState(
      MainScreenState state) async* {
    LogUtil.d("处理定位数据~_baiduLocation：${_baiduLocation?.address}");

    if (_baiduLocation == null) {
      //定位失败
      yield FailedLoadMainScreenState(ApplicationError.locationError);
    } else {
      //定位成功
      final Coordinate geoPosition =
          Coordinate.fromBaiduLocation(_baiduLocation!);
      _weatherLocalRepository.saveCoordinate(geoPosition);
      add(WeatherDataLoadedMainEvent());
    }
  }

  Stream<MainScreenState> _mapWeatherToState(MainScreenState state) async* {
    LogUtil.d("定位成功..加载天气数据~");
    if (state is LocationChangedState) {
      if (_baiduLocation != null) {
        //获取天气信息
        final WeatherResponse? weatherResponse = await _fetcherWeather(
            _baiduLocation!.latitude, _baiduLocation!.longitude);

        //获取天气预测信息
        final WeatherForecastListResponse? weatherForecastListResponse =
            await _fetcherWeatherForecast(
                _baiduLocation!.latitude, _baiduLocation!.longitude);

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
          yield const FailedLoadMainScreenState(
              ApplicationError.connectionError);
        }
      }
    } else {
      yield const FailedLoadMainScreenState(ApplicationError.locationError);
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
          await _weatherLocalRepository.getCachedWeatherForecast();

      if (cacheResponse != null) {
        weatherForecastResponse = cacheResponse;
      }
    }
    return weatherForecastResponse;
  }

  ///获取天气数据
  Future<WeatherResponse?> _fetcherWeather(
      double? latitude, double? longitude) async {
    LogUtil.d("请求天气数据~");

    final WeatherResponse weatherResponse =
        await _weatherRemoteRepository.fetchWeather(latitude, longitude);

    if (weatherResponse.errorCode == null) {
      _weatherLocalRepository.saveWeather(weatherResponse);
      return weatherResponse;
    } else {
      LogUtil.d("load cache weather data~");
      final WeatherResponse? weatherCacheResponse =
          await _weatherLocalRepository.getCachedWeather();
      if (weatherCacheResponse != null) {
        return weatherCacheResponse;
      }
    }
  }

  @override
  void onTransition(Transition<MainScreenEvent, MainScreenState> transition) {
    super.onTransition(transition);
    LogUtil.d("MainScreenBloc..$transition");
    // print(transition);
  }
}
