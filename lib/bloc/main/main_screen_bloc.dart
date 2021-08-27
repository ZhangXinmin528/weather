import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';
import 'package:weather/data/model/internal/weather_error.dart';
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

  Timer? _refreshTimer;

  MainScreenBloc(
      this._weatherRemoteRepository, this._applicationLocalRepository)
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
      yield FailedLoadMainScreenState(WeatherError.locationError);
    } else {
      //定位成功
      add(WeatherDataLoadedMainEvent());
    }
  }

  Stream<MainScreenState> _mapWeatherToState(MainScreenState state) async* {
    LogUtil.d("定位成功..加载天气数据~");
    if (state is LocationChangedState) {
      if (_baiduLocation != null) {
        //获取天气信息
        final Weather weather =
            await _weatherRemoteRepository.requestWeatherNow(
                _baiduLocation!.longitude, _baiduLocation!.latitude);
        LogUtil.d("code=${weather.code}");
        if (weather != null) {
          if (weather.code != 200) {
            yield FailedLoadMainScreenState(WeatherError.data_not_available);
          } else {
            //加载天气数据
            print(weather);
            yield SuccessLoadMainScreenState(weather);
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
