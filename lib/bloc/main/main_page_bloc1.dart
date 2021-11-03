import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_page_event1.dart';
import 'package:weather/bloc/main/main_page_state1.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/local/app_local_repository.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/log_utils.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final LocationManager _locationManager = LocationManager();
  final WeatherRemoteRepository _weatherRemoteRepository;

  final AppLocalRepository _appLocalRepo;

  late BaiduLocation? _baiduLocation;

  MainPageBloc(this._weatherRemoteRepository, this._appLocalRepo)
      : super(InitLocationState()) {
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
  Stream<MainPageState> mapEventToState(MainPageState event) async* {
    LogUtil.d("mapEventToState..$event");

    if (event is InitLocationState) {
      yield* _mapStartLocationToState(state);
      // } else if (event is RefreshMainEvent) {
      //   //刷新定位
      //   yield* _mapRefreshToState(state);
    } else if (event is LocationChangedEvent) {
      //定位数据变化
      yield* _mapLocationChangedToState(state);
    } else if (event is WeatherDataLoadedMainEvent) {
      //请求天气数据
      yield* _mapWeatherToState(state);
    }
  }

  ///开始定位
  Stream<MainPageState> _mapStartLocationToState(MainPageState state) async* {
    LogUtil.d("_mapStartLocationToState：${state is InitLocationState}");
    if (state is InitLocationState) {

      _locationManager.startLocation();
    }
  }

  ///定位相关逻辑
  Stream<MainPageState> _mapLocationChangedToState(MainPageState state) async* {
    LogUtil.e("_mapLocationChangedToState..定位数据：${_baiduLocation?.address}");
    if (_baiduLocation != null && _baiduLocation!.city != null) {
      final String json = convert.jsonEncode(_baiduLocation!.getMap());
      _appLocalRepo.saveLocation(json);
      //定位成功
      yield LocationSuccessState();
      add(WeatherDataLoadedMainEvent());
    } else {
      LogUtil.e("定位回调了..定位失败~");
      //定位失败
      yield FailedLoadMainScreenState(WeatherError.locationError);
    }
  }

  Stream<MainPageState> _mapWeatherToState(MainPageState state) async* {
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
}
