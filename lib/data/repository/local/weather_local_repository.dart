import 'package:weather/data/model/internal/coordinate.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/data/repository/local/storage_manager.dart';

///天气本地缓存信息
class WeatherLocalRepository {
  final StorageManager _storageManager;

  WeatherLocalRepository(this._storageManager);

  Future saveCoordinate(Coordinate geoPosition) async {
    await _storageManager.saveLocation(geoPosition);
  }

  Future<Coordinate?> getCachedCoordinate() async {
    return _storageManager.getLocation();
  }

  Future saveWeather(WeatherResponse response) async {
    await _storageManager.saveWeather(response);
  }

  Future<WeatherResponse?> getCachedWeather() async {
    return _storageManager.getWeather();
  }

  Future saveWeatherForecast(WeatherForecastListResponse response) async {
    await _storageManager.saveWeatherForecast(response);
  }

  Future<WeatherForecastListResponse?> getCachedWeatherForecast() async {
    return _storageManager.getWeatherForecast();
  }
}
