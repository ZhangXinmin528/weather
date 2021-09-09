import 'package:equatable/equatable.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';

class MainScreenState extends Equatable {
  final Unit? unit;

  const MainScreenState({this.unit});

  @override
  List<Object?> get props => [unit];
}

///开始定位
class StartLocationState extends MainScreenState {}

///定位失败
class LocationFaliedState extends MainScreenState {
  final WeatherError error;

  const LocationFaliedState(this.error);

  @override
  List<Object?> get props => [unit, error];
}

///定位成功
class LocationSuccessState extends MainScreenState {}

///加载主屏幕
class LoadingMainScreenState extends MainScreenState {}

///主屏幕数据加载成功
class SuccessLoadMainScreenState extends MainScreenState {
  final WeatherRT weather;
  final WeatherAir weatherAir;
  final BaiduLocation location;

  SuccessLoadMainScreenState(this.weather, this.weatherAir, this.location);

  @override
  List<Object?> get props => [weather, weatherAir, location, unit];
}

///主页面加载天气失败
class FailedLoadMainScreenState extends MainScreenState {
  final WeatherError error;

  const FailedLoadMainScreenState(this.error);

  @override
  List<Object?> get props => [unit, error];
}
