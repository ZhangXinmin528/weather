import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/data/repository/remote/weather_api_provider.dart';

class WeatherRemoteRepository {
  final WeatherApiProvider _weatherApiProvider;

  WeatherRemoteRepository(this._weatherApiProvider);

  ///获取天气信息
  Future<WeatherResponse> fetchWeather(double? latitude, double? longitude) {
    return _weatherApiProvider.fetchWeather(latitude, longitude);
  }

  ///获取天气预报信息
  Future<WeatherForecastListResponse> fetcherForecast(
      double? latitude, double? longitude) {
    return _weatherApiProvider.fetchWeatherForecast(latitude, longitude);
  }
}
