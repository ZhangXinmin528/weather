import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/tab_element.dart';

class WeatherPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///加载缓存的天气数据¬
class LoadCachedWeatherEvent extends WeatherPageEvent{
  final CityElement cityElement;

  LoadCachedWeatherEvent(this.cityElement);

  @override
  List<Object?> get props => [cityElement];
}
///网络请求天气数据
class InitWeatherNetEvent extends WeatherPageEvent {
  final CityElement cityElement;

  InitWeatherNetEvent(this.cityElement);

  @override
  List<Object?> get props => [cityElement];
}
