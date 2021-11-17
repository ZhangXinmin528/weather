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

  ///城市天气API
  ///实时天气
  Future<WeatherRT?> requestWeatherNow(
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

    if (response != null && response.statusCode == 200) {
      return WeatherRT.fromJson(response.data);
    }
    return null;
  }

  ///7天天气预报
  Future<WeatherDaily?> requestWeather7D(
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

    if (response != null && response.statusCode == 200) {
      return WeatherDaily.fromJson(response.data);
    }
    return null;
  }

  ///24H天气预报
  Future<WeatherHour?> requestWeather24H(
    double? longitude,
    double? latitude, {
    Function()? onStart,
    required Function(Map<String, dynamic>? map) onResponse,
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

    if (response != null && response.statusCode == 200) {
      return WeatherHour.fromJson(response.data);
    }
    return null;
  }

//===========================================================================//

  ///天气指数API
  ///天气生活指数
  Future<WeatherIndices?> requestIndices1D(
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
      'type': "1,2,3,5,6,7,8,9", //运动指数，洗车指数，穿衣指数，紫外线指数，旅游指数，花粉过敏指数，舒适度指数，感冒指数；
    };
    final response = await _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    if (response != null && response.statusCode == 200) {
      return WeatherIndices.fromJson(response.data);
    }
    return null;
  }

//===========================================================================//

  ///灾害预警API
  ///极端天气预报数据
  Future<WeatherWarning?> requestWarningNow(
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

    if (response != null && response.statusCode == 200) {
      return WeatherWarning.fromJson(response.data);
    }
    return null;
  }

//===========================================================================//

  ///空气API
  ///实时空气质量
  Future<WeatherAir?> requestAirNow(
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

    if (response != null && response.statusCode == 200) {
      return WeatherAir.fromJson(response.data);
    }
    return null;
  }

  ///空气质量预报
  Future<AirDaily?> requestAir5D(
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

    if (response != null && response.statusCode == 200) {
      return AirDaily.fromJson(response.data);
    }
    return null;
  }

//===========================================================================//

  ///天文API
  ///日出日落
  Future<AstronomySun?> requestAstronomySun(
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

    if (response != null && response.statusCode == 200) {
      return AstronomySun.fromJson(response.data);
    }
    return null;
  }

  ///月升月落和月相
  Future<AstronomyMoon?> requestAstronomyMoon(
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

    if (response != null && response.statusCode == 200) {
      return AstronomyMoon.fromJson(response.data);
    }
    return null;
  }

//===========================================================================//

  ///地理信息API
  ///城市信息查询：目前中国范围内
  Future<CityLocation?> requestCityLookup(
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
    final response = _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    if (response != null && response.statusCode == 200) {
      return CityLocation.fromJson(response.data);
    }
    return null;
  }

  ///热门城市查询：目前中国范围内
  Future<CityTop?> requestCityTop({
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
    final response = _dioClient.get(
      path,
      queryParameters: params,
      onStart: onStart,
      onError: onError,
    );

    if (response != null && response.statusCode == 200) {
      return CityTop.fromJson(response.data);
    }
    return null;
  }
}
