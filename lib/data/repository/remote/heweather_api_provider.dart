import 'package:dio/dio.dart';
import 'package:weather/resources/config/app_config.dart';

class HeWeatherApiProvider {
  final _baseApi = 'https://devapi.qweather.com/v7';

  ///城市天气API
  final _cityWeatherPoint = "/weather";

  //实时天气
  final _cityWeatherNow = "/now";

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

    // _dio.interceptors.add(PrettyDioLogger());
  }

  Future<Response> requestWeatherNow(double longitude, double latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeatherNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };

    return await _dio.get(path, queryParameters: params);
  }
}
