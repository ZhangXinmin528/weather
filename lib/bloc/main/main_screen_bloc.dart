import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repository/local/application_local_repository.dart';
import 'package:weather/data/repository/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/log_utils.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final LocationManager _locationManager = LocationManager();
  final WeatherRemoteRepository _weatherRemoteRepository;

  final ApplicationLocalRepository _applicationLocalRepository;

  late BaiduLocation? _baiduLocation;

  MainScreenBloc(
      this._weatherRemoteRepository, this._applicationLocalRepository)
      : super(StartLocationState()) {
    _locationManager.listenLocationCallback((value) {
      //定位变化
      _baiduLocation = value;
      Future.delayed(Duration(seconds: 1), () {
        add(LocationChangedEvent());
      });
      _locationManager.stopLocation();
      LogUtil.d("定位回调了..定位街道：：${_baiduLocation?.district}");
    });
  }

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    LogUtil.d("mapEventToState..$event");

    if (event is StartLocationEvent) {
      //开始定位
      yield* _mapStartLocationToState(state);
    } else if (event is RefreshMainEvent) {
      //刷新定位
      yield* _mapRefreshToState(state);
    } else if (event is LocationChangedEvent) {
      //定位数据变化
      yield* _mapLocationChangedToState(state);
    } else if (event is WeatherDataLoadedMainEvent) {
      //请求天气数据
      yield* _mapWeatherToState(state);
    }
  }

  ///开始定位
  Stream<MainScreenState> _mapStartLocationToState(
      MainScreenState state) async* {
    LogUtil.d("_mapStartLocationToState：${state is StartLocationState}");
    if (state is StartLocationState) {
      _locationManager.startLocation();
    }
  }

  ///刷新
  Stream<MainScreenState> _mapRefreshToState(MainScreenState state) async* {
    _locationManager.startLocation();
  }

  ///定位相关逻辑
  Stream<MainScreenState> _mapLocationChangedToState(
      MainScreenState state) async* {
    LogUtil.e("_mapLocationChangedToState..定位数据：${_baiduLocation?.address}");
    if (_baiduLocation != null && _baiduLocation!.city != null) {
      //定位成功
      yield LocationSuccessState();
      add(WeatherDataLoadedMainEvent());
    } else {
      LogUtil.e("定位回调了..定位失败~");
      //定位失败
      yield FailedLoadMainScreenState(WeatherError.locationError);
    }
  }

  Stream<MainScreenState> _mapWeatherToState(MainScreenState state) async* {
    LogUtil.d("定位成功..加载天气数据~");

    if (state is LocationSuccessState) {
      if (_baiduLocation != null) {
        //获取天气信息
        final WeatherRT weatherNow =
            await _weatherRemoteRepository.requestWeatherNow(
                _baiduLocation!.longitude, _baiduLocation!.latitude);

        //实时空气质量
        final WeatherAir weatherAir = await _weatherRemoteRepository
            .requestAirNow(_baiduLocation!.longitude, _baiduLocation!.latitude);

        //24H
        final WeatherHour weatherHour =
            await _weatherRemoteRepository.requestWeather24H(
                _baiduLocation!.longitude, _baiduLocation!.latitude);

        //7D
        final WeatherDaily weatherDaily =
            await _weatherRemoteRepository.requestWether7D(
                _baiduLocation!.longitude, _baiduLocation!.latitude);

        //当天天气指数
        final WeatherIndices weatherIndices =
            await _weatherRemoteRepository.requestIndices1D(
                _baiduLocation!.longitude, _baiduLocation!.latitude);

        //极端天气预警
        // final WeatherWarning warning =
        //     await _weatherRemoteRepository.requestWarningNow(
        //         _baiduLocation!.longitude, _baiduLocation!.latitude);

        //空气质量预报
        // final AirDaily airDaily = await _weatherRemoteRepository.requestAir5D(
        //     _baiduLocation!.longitude, _baiduLocation!.latitude);

        //日出日落
        // final AstronomySun sun =
        //     await _weatherRemoteRepository.requestAstronomySun(
        //         _baiduLocation!.longitude, _baiduLocation!.latitude);

        //月升月落
        // final AstronomyMoon moon =
        //     await _weatherRemoteRepository.requestAstronomyMoon(
        //         _baiduLocation!.longitude, _baiduLocation!.latitude);

        if (weatherNow != null) {
          if (weatherNow.code != "200") {
            yield FailedLoadMainScreenState(WeatherError.data_not_available);
          } else {
            yield SuccessLoadMainScreenState(weatherNow, weatherAir,
                weatherDaily, weatherHour, weatherIndices, _baiduLocation!);
          }
        } else {
          yield const FailedLoadMainScreenState(WeatherError.connectionError);
        }
      }
    } else {
      yield const FailedLoadMainScreenState(WeatherError.locationError);
    }
  }

  @override
  void onTransition(Transition<MainScreenEvent, MainScreenState> transition) {
    super.onTransition(transition);
    LogUtil.d("MainScreenBloc..$transition");
    // print(transition);
  }
}
