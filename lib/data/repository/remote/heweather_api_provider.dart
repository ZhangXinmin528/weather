import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/resources/config/app_config.dart';

class HeWeatherApiProvider {
  final _baseApi = 'https://devapi.qweather.com/v7';

  ///城市天气API
  final _cityWeatherPoint = "/weather";

  //实时天气
  final _cityWeatherNow = "/now";

  //7天天气
  final _cityWeather7D = "/7d";

  //24小时天气
  final _cityWeather24H = "24h";

  late Dio _dio;

  factory HeWeatherApiProvider() {
    return _instance;
  }

  static late final HeWeatherApiProvider _instance =
      HeWeatherApiProvider._internal();

  HeWeatherApiProvider._internal() {
    final _baseOptions = BaseOptions();
    _baseOptions.connectTimeout = 30 * 1000;
    _baseOptions.receiveTimeout = 30 * 1000;
    _dio = Dio(_baseOptions);

    _dio.interceptors.add(PrettyDioLogger());
  }

  ///城市天气API
  ///实时天气
  Future<Response> requestWeatherNow(double longitude, double latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeatherNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };

    return await _dio.get(path, queryParameters: params);
  }

  ///7天天气预报
  Future<Response> requestWeather7D(double longitude, double latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeather7D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

  ///24H天气预报
  Future<Response> requestWeather24H(double longitude, double latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeather24H;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

}
