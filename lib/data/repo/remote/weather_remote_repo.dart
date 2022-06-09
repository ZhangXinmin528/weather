import 'package:dio/dio.dart';
import 'package:weather/data/model/remote/city/city_location.dart';
import 'package:weather/data/model/remote/city/city_top.dart';
import 'package:weather/data/model/remote/weather/air_daily.dart';
import 'package:weather/data/model/remote/weather/astronomy_moon.dart';
import 'package:weather/data/model/remote/weather/astronomy_sun.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/http/dio_client.dart';
import 'package:weather/http/http_exception.dart';
import 'package:weather/http/http_result.dart';
import 'package:weather/resources/config/app_config.dart';
import 'package:weather/utils/datetime_utils.dart';

class WeatherRemoteRepo {
  final _weatherApi = 'https://devapi.qweather.com/v7';
  final _geoApi = "https://geoapi.qweather.com/v2";

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

  ///地理信息API
  final String _cityPoint = "/city";

  //城市信息查询
  final String _cityLookup = "/lookup";

  //热门城市
  final String _topCity = "/top";

  late DioClient _dioClient;

  factory WeatherRemoteRepo() {
    return _instance;
  }

  static late final WeatherRemoteRepo _instance = WeatherRemoteRepo._internal();

  WeatherRemoteRepo._internal() {
    _dioClient = DioClient.instance;
  }

  ///解析Response
  Future<HttpResult<T?>> onResponse<T>(
    Response? response,
    T? t,
  ) async {
    if (response != null) {
      if (response.statusCode == 200) {
        return HttpResult(response.statusCode ?? 200, "success", t);
      } else {
        return HttpResult(response.statusCode ?? -1,
            response.statusMessage ?? "failure", null);
      }
    } else {
      return HttpResult(-1, "failure", null);
    }
  }

  ///城市天气API
  ///实时天气
  Future<HttpResult<WeatherRT?>> requestWeatherNow(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _cityWeatherPoint + _cityWeatherNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };

    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherRT.fromJson(response?.data));
  }

  ///7天天气预报
  Future<HttpResult<WeatherDaily?>> requestWeather7D(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _cityWeatherPoint + _cityWeather7D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherDaily.fromJson(response?.data));
  }

  ///24H天气预报
  Future<HttpResult<WeatherHour?>> requestWeather24H(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _cityWeatherPoint + _cityWeather24H;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherHour.fromJson(response?.data));
  }

//===========================================================================//

  ///天气指数API
  ///天气生活指数
  Future<HttpResult<WeatherIndices?>> requestIndices1D(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _indicesPoint + _indices1D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'type': "1,2,3,5,6,7,8,9,14",
      //运动指数，洗车指数，穿衣指数，紫外线指数，旅游指数，花粉过敏指数，舒适度指数，感冒指数，晾晒指数；
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherIndices.fromJson(response?.data));
  }

//===========================================================================//

  ///灾害预警API
  ///极端天气预报数据
  Future<HttpResult<WeatherWarning?>> requestWarningNow(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _warningPoint + _warningNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherWarning.fromJson(response?.data));
  }

//===========================================================================//

  ///空气API
  ///实时空气质量
  Future<HttpResult<WeatherAir?>> requestAirNow(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _airPoint + _airNow;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, WeatherAir.fromJson(response?.data));
  }

  ///空气质量预报
  Future<HttpResult<AirDaily?>> requestAir5D(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _airPoint + _air5D;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, AirDaily.fromJson(response?.data));
  }

//===========================================================================//

  ///天文API
  ///日出日落
  Future<HttpResult<AstronomySun?>> requestAstronomySun(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _astronomyPoint + _astronomySun;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'date': DateTimeUtils.formatDateTime(DateTime.now(), "yyyyMMdd"),
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, AstronomySun.fromJson(response?.data));
  }

  ///月升月落和月相
  Future<HttpResult<AstronomyMoon?>> requestAstronomyMoon(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _weatherApi + _astronomyPoint + _astronomyMoon;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$longitude,$latitude",
      'date': DateTimeUtils.formatDateTime(DateTime.now(), "yyyyMMdd"),
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, AstronomyMoon.fromJson(response?.data));
  }

//===========================================================================//

  ///地理信息API
  ///城市信息查询：目前中国范围内
  Future<HttpResult<CityLocation?>> requestCityLookup(
    String city, {
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _geoApi + _cityPoint + _cityLookup;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'location': "$city",
      'range': "cn",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, CityLocation.fromJson(response?.data));
  }

  ///热门城市查询：目前中国范围内
  Future<HttpResult<CityTop?>> requestCityTop({
    Function()? onStart,
    Function(HttpException error)? onError,
  }) async {
    final path = _geoApi + _cityPoint + _topCity;
    //参数
    final Map<String, dynamic> params = {
      'key': AppConfig.weather_key,
      'range': "cn",
      'number': "20",
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    return onResponse(response, CityTop.fromJson(response?.data));
  }
}
