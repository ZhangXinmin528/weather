import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';

class WeatherPageState extends Equatable {

  const WeatherPageState();

  @override
  List<Object?> get props => [];
}

///开始请求天气数据
class StartReuestWeatherState extends WeatherPageState {}

///天气数据请求成功
class RequestWeatherSuccessState extends WeatherPageState {
  final WeatherRT weather;
  final WeatherAir weatherAir;
  final WeatherDaily weatherDaily;
  final WeatherIndices weatherIndices;
  final WeatherHour weatherHour;

  RequestWeatherSuccessState(this.weather, this.weatherAir, this.weatherDaily,
      this.weatherIndices, this.weatherHour);

  @override
  List<Object?> get props => [
        weather,
        weatherAir,
        weatherDaily,
      ];
}

///天气数据请求失败
class RequestWeatherFailedState extends WeatherPageState {
  final WeatherError error;

  const RequestWeatherFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
