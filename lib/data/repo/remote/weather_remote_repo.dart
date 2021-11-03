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

import 'heweather_api_provider.dart';

class WeatherRemoteRepository {
  final HeWeatherApiProvider _weatherApiProvider;

  WeatherRemoteRepository(this._weatherApiProvider);

  //==========================================================================//
  ///城市天气API
  ///获取实时天气信息
  Future<WeatherRT> requestWeatherNow(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestWeatherNow(longitude, latitude);

    // LogUtil.d("response=${response.data.toString()}");
    final WeatherRT weather = WeatherRT.fromJson(response.data);
    return weather;
  }

  ///获取7天天气预报
  Future<WeatherDaily> requestWether7D(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestWeather7D(longitude, latitude);

    final WeatherDaily daily = WeatherDaily.fromJson(response.data);
    return daily;
  }

  ///获取24小时天气预报
  Future<WeatherHour> requestWeather24H(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestWeather24H(longitude, latitude);
    final WeatherHour hour = WeatherHour.fromJson(response.data);
    return hour;
  }

  //=========================================================================//

  ///天气指数API
  ///获取当天天气指数
  Future<WeatherIndices> requestIndices1D(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestIndices1D(longitude, latitude);
    final WeatherIndices indices = WeatherIndices.fromJson(response.data);
    return indices;
  }

  //=========================================================================//
  ///天气灾害预警API
  ///获取极端天气预警
  Future<WeatherWarning> requestWarningNow(
      double longitude, double latitude) async {
    final response =
        await _weatherApiProvider.requestWarningNow(longitude, latitude);
    final WeatherWarning warning = WeatherWarning.fromJson(response.data);
    return warning;
  }

//=========================================================================//

  ///空气API
  ///实时空气质量
  Future<WeatherAir> requestAirNow(double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestAirNow(longitude, latitude);
    final WeatherAir air = WeatherAir.fromJson(response.data);
    return air;
  }

  ///实时空气质量
  Future<AirDaily> requestAir5D(double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestAir5D(longitude, latitude);
    final AirDaily air = AirDaily.fromJson(response.data);
    return air;
  }

//=========================================================================//

  ///天文API
  ///日出日落数据
  Future<AstronomySun> requestAstronomySun(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestAstronomySun(longitude, latitude);
    final AstronomySun sun = AstronomySun.fromJson(response.data);
    // LogUtil.d("response=${response.data.toString()}");
    return sun;
  }

  ///月升月落和月相
  Future<AstronomyMoon> requestAstronomyMoon(
      double? longitude, double? latitude) async {
    final response =
        await _weatherApiProvider.requestAstronomyMoon(longitude, latitude);
    // LogUtil.d("response=${response.data.toString()}");
    final AstronomyMoon moon = AstronomyMoon.fromJson(response.data);
    return moon;
  }

//===========================================================================//

  ///地理信息API
  ///城市信息查询：目前中国范围内
  Future<CityLocation> requestCityLookup(String city) async {
    final response = await _weatherApiProvider.requestCityLookup(city);
    final CityLocation cityLocation = CityLocation.fromJson(response.data);
    return cityLocation;
  }

  ///热门城市查询：目前中国范围内
  Future<CityTop> requestCityTop() async {
    final response = await _weatherApiProvider.requestCityTop();
    final CityTop cityTop = CityTop.fromJson(response.data);
    return cityTop;
  }
}
