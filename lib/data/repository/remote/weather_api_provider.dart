import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/data/model/internal/application_error.dart';
import 'package:weather/data/model/remote/weather_forecast_list_response.dart';
import 'package:weather/data/model/remote/weather_response.dart';
import 'package:weather/resources/config/application_config.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherApiProvider {
  final _apiBaseUrl = 'api.openweathermap.org';
  final _apiPath = '/data/2.5';
  final _apiWeatherEndpoint = '/weather';
  final _apiWeatherForecastEndpoint = '/forecast';

  final _dio = Dio();

  ///获取天气信息
  Future<WeatherResponse> fetchWeather(double? latitude, double? longitude) async {
    try {
      final Uri uri = _buildUri(_apiWeatherEndpoint, latitude, longitude);
      LogUtil.e("Fetcher weather:${uri.toString()}");
      final Response<Map<String, dynamic>> response =
          await _dio.get(uri.toString());

      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data!);
      } else {
        return WeatherResponse.withErrorCode(ApplicationError.apiError);
      }
    } catch (exception, stacktrace) {
      LogUtil.e("Exception occurred:$exception, stack trace:$stacktrace");
      return WeatherResponse.withErrorCode(ApplicationError.connectionError);
    }
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double? latitude, double? longitude) async {
    try {
      final uri = _buildUri(_apiWeatherForecastEndpoint, latitude, longitude);
      final Response<Map<String, dynamic>> response =
          await _dio.get(uri.toString());

      if (response.statusCode == 200) {
        return WeatherForecastListResponse.fromJson(response.data!);
      } else {
        return WeatherForecastListResponse.withErrorCode(
            ApplicationError.apiError);
      }
    } catch (exception, stackTrace) {
      LogUtil.e("Exception occured:$exception $stackTrace");
      return WeatherForecastListResponse.withErrorCode(
          ApplicationError.connectionError);
    }
  }

  ///build uri for http request.
  Uri _buildUri(String endpoint, double? latitude, double? longitude) {
    return Uri(
        scheme: "https",
        host: _apiBaseUrl,
        path: '$_apiPath$endpoint',
        queryParameters: <String, dynamic>{
          'lat': latitude,
          'lon': longitude,
          'apiKey': AppConfig.apikey,
          'units': 'metric'
        });
  }

  void setupInterceptors() {
    _dio.interceptors.add(PrettyDioLogger());
  }
}
