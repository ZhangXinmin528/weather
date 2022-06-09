import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';

abstract class WeatherPageState extends Equatable {
  WeatherPageState();
}

///加载缓存的天气数据
class LoadCachedWeatherDataState extends WeatherPageState {
  @override
  List<Object?> get props => [];
}

///开始请求天气数据
class StartRequestWeatherState extends WeatherPageState {
  @override
  List<Object?> get props => [];
}

///天气数据请求成功
class LoadWeatherToPageState extends WeatherPageState {
  final String key;
  final WeatherRT? weather;
  final WeatherAir? weatherAir;
  final WeatherDaily? weatherDaily;
  final WeatherIndices? weatherIndices;
  final WeatherHour? weatherHour;

  LoadWeatherToPageState(this.key, this.weather, this.weatherAir,
      this.weatherDaily, this.weatherIndices, this.weatherHour);

  @override
  List<Object?> get props => [
        key,
        weather,
        weatherAir,
        weatherDaily,
      ];
}

///天气数据请求失败
class RequestWeatherFailedState extends WeatherPageState {
  final WeatherError error;

  RequestWeatherFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
