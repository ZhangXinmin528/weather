import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';

class MainScreenState extends Equatable {
  final Unit? unit;

  const MainScreenState({this.unit});

  @override
  List<Object?> get props => [unit];
}

///开始定位
class StartLocationState extends MainScreenState {}

///定位变化
class LocationChangedState extends MainScreenState {}

///加载主屏幕
class LoadingMainScreenState extends MainScreenState {}

///主屏幕数据加载成功
class SuccessLoadMainScreenState extends MainScreenState {
  final Weather weather;

  SuccessLoadMainScreenState(this.weather);

  @override
  List<Object?> get props => [weather, unit];
}

///主页面加载天气失败
class FailedLoadMainScreenState extends MainScreenState {
  final WeatherError error;

  const FailedLoadMainScreenState(this.error);

  @override
  List<Object?> get props => [unit, error];
}
