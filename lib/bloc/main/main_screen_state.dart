import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/application_error.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';

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
  final WeatherResponse weatherResponse;
  final WeatherForecastListResponse weatherForecastListResponse;

  SuccessLoadMainScreenState(
      this.weatherResponse, this.weatherForecastListResponse);

  @override
  List<Object?> get props => [unit, weatherResponse];
}

///主页面加载天气失败
class FailedLoadMainScreenState extends MainScreenState {
  final ApplicationError error;

  const FailedLoadMainScreenState(this.error);

  @override
  List<Object?> get props => [unit, error];
}
