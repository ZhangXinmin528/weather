import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/resources/config/app_config.dart';
import 'package:weather/utils/datetime_utils.dart';

class HeWeatherApiProvider {
  final _baseApi = 'https://devapi.qweather.com/v7';

  ///1.城市天气API
  final _cityWeatherPoint = "/weather";

  //实时天气
  final _cityWeatherNow = "/now";

  //7天天气
  final _cityWeather7D = "/7d";

  //24小时天气
  final _cityWeather24H = "/24h";

  ///2.天气生活指数
  final String _indicesPoint = "/indices";

  //当天生活指数
  final String _indices1D = "/1d";

  ///3.天气灾害预警
  final String _warningPoint = "/warning";

  //极端天气预警
  final String _warningNow = "/now";

  ///4.空气API
  final String _airPoint = "/air";

  //实时空气质量
  final String _airNow = "/now";

  //空气质量预报
  final String _air5D = "/5d";

  ///天文API
  final String _astronomyPoint = "/astronomy";

  //日出日落
  final String _astronomySun = "/sun";

  //月升月落和月相
  final String _astronomyMoon = "/moon";

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
  Future<Response> requestWeatherNow(
      double? longitude, double? latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeatherNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };

    return await _dio.get(path, queryParameters: params);
  }

  ///7天天气预报
  Future<Response> requestWeather7D(double? longitude, double? latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeather7D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

  ///24H天气预报
  Future<Response> requestWeather24H(double? longitude, double? latitude) async {
    final path = _baseApi + _cityWeatherPoint + _cityWeather24H;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

//===========================================================================//

  ///天气指数API
  ///天气生活指数
  Future<Response> requestIndices1D(double? longitude, double? latitude) async {
    final path = _baseApi + _indicesPoint + _indices1D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'type': "1,2,3,5,6,7,8,9", //运动指数，洗车指数，穿衣指数，紫外线指数，旅游指数，花粉过敏指数，舒适度指数，感冒指数；
    };
    return await _dio.get(path, queryParameters: params);
  }

//===========================================================================//

  ///灾害预警API
  ///极端天气预报数据
  Future<Response> requestWarningNow(double? longitude, double? latitude) async {
    final path = _baseApi + _warningPoint + _warningNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

//===========================================================================//

  ///空气API
  ///实时空气质量
  Future<Response> requestAirNow(double? longitude, double? latitude) async {
    final path = _baseApi + _airPoint + _airNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

  ///空气质量预报
  Future<Response> requestAir5D(double? longitude, double? latitude) async {
    final path = _baseApi + _airPoint + _air5D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    return await _dio.get(path, queryParameters: params);
  }

//===========================================================================//

  ///天文API
  ///日出日落
  Future<Response> requestAstronomySun(
      double? longitude, double? latitude) async {
    final path = _baseApi + _astronomyPoint + _astronomySun;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'date': DateTimeUtils.formatDateTime(DateTime.now(), "yyyyMMdd"),
    };
    return await _dio.get(path, queryParameters: params);
  }

  ///月升月落和月相
  Future<Response> requestAstronomyMoon(
      double? longitude, double? latitude) async {
    final path = _baseApi + _astronomyPoint + _astronomyMoon;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'date': DateTimeUtils.formatDateTime(DateTime.now(), "yyyyMMdd"),
    };
    return await _dio.get(path, queryParameters: params);
  }
}
