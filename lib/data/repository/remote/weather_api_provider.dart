import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/resources/config/application_config.dart';

class WeatherApiProvider {
  final _apiBaseUrl = 'api.openweathermap.org';
  final _apiPath = '/data/2.5';
  final _apiWeatherEndpoint = '/weather';
  final _apiWeatherForecastEndpoint = '/forecast';

  final _dio = Dio();

  ///获取天气信息
  Future fetchWeather(double? latitude, double? longitude) async {
    try {
      final Uri uri = _buildUri(_apiWeatherEndpoint, latitude, longitude);

      final Response<Map<String, dynamic>> response =
      await _dio.get(uri.toString());

      if(response.statusCode == 200){
        return
      }
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
