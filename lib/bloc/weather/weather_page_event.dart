import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/tab_element.dart';

class WeatherPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///加载天气数据
class InitWeatherPageEvent extends WeatherPageEvent {
  final CityElement cityElement;

  InitWeatherPageEvent(this.cityElement);

  @override
  List<Object?> get props => [cityElement];
}
