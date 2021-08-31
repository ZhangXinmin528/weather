import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/data/repository/remote/heweather_api_provider.dart';

class WeatherRemoteRepository {
  final HeWeatherApiProvider _weatherApiProvider;

  WeatherRemoteRepository(this._weatherApiProvider);

  //==========================================================================//
  ///城市天气API
  ///获取实时天气信息
  Future<WeatherRT> requestWeatherNow(double longitude, double latitude) async {
    final response =
        await _weatherApiProvider.requestWeatherNow(longitude, latitude);

    // LogUtil.d("response=${response.data.toString()}");
    final WeatherRT weather = WeatherRT.fromJson(response.data);
    return weather;
  }

  ///获取7天天气预报
  Future<WeatherDaily> requestWether7D(
      double longitude, double latitude) async {
    final response =
        await _weatherApiProvider.requestWeather7D(longitude, latitude);

    final WeatherDaily daily = WeatherDaily.fromJson(response.data);
    return daily;
  }

  ///获取24小时天气预报
  Future<WeatherHour> requestWeather24H(
      double longitude, double latitude) async {
    final response =
        await _weatherApiProvider.requestWeather24H(longitude, latitude);
    final WeatherHour hour = WeatherHour.fromJson(response.data);
    return hour;
  }

  //=========================================================================//

  ///天气指数API
  ///获取当天天气指数
  Future<WeatherIndices> requestIndices1D(
      double longitude, double latitude) async {
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

}
