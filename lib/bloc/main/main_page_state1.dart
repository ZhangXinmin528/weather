import 'package:equatable/equatable.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';

class MainPageState extends Equatable {
  const MainPageState();

  @override
  List<Object?> get props => [];
}

///定位信息获取
class InitLocationState extends MainPageState {}

///定位失败
// class LocationFaliedState extends MainScreenState {
//   final WeatherError error;
//
//   const LocationFaliedState(this.error);
//
//   @override
//   List<Object?> get props => [unit, error];
// }

///定位成功
class LocationSuccessState extends MainPageState {}

///加载主屏幕
class LoadingMainScreenState extends MainPageState {}

///主屏幕数据加载成功
class SuccessLoadMainScreenState extends MainPageState {
  final WeatherRT weather;
  final WeatherAir weatherAir;
  final WeatherDaily weatherDaily;
  final WeatherIndices weatherIndices;
  final WeatherHour weatherHour;

  final BaiduLocation location;

  SuccessLoadMainScreenState(this.weather, this.weatherAir, this.weatherDaily,
      this.weatherHour, this.weatherIndices, this.location);

  @override
  List<Object?> get props => [weather, weatherAir, weatherDaily, location];
}

///主页面加载天气失败
class FailedLoadMainScreenState extends MainPageState {
  final WeatherError error;

  const FailedLoadMainScreenState(this.error);

  @override
  List<Object?> get props => [error];
}
