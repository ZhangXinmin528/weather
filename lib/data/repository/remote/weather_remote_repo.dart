import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repository/remote/heweather_api_provider.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherRemoteRepository {
  final HeWeatherApiProvider _weatherApiProvider;

  WeatherRemoteRepository(this._weatherApiProvider);

  ///获取天气信息
  Future<Weather> requestWeatherNow(double longitude, double latitude) async {
    final response =
        await _weatherApiProvider.requestWeatherNow(longitude, latitude);

    LogUtil.d("response=${response.data.toString()}");
    final Weather weather = Weather.fromJson(response.data);
    // Weather.fromJson(json.decode(response.data.toString()));
    print(weather.code);
    return weather;
  }
}
