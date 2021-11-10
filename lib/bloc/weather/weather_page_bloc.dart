import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather/weather_page_event.dart';
import 'package:weather/bloc/weather/weather_page_state.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/local/sqlite_manager.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherPageBloc extends Bloc<WeatherPageEvent, WeatherPageState> {
  final WeatherRemoteRepository _weatherRemoteRepository;
  final SqliteManager _sqliteManager = SqliteManager.INSTANCE;

  WeatherPageBloc(this._weatherRemoteRepository)
      : super(LoadCachedWeatherDataState());

  @override
  Stream<WeatherPageState> mapEventToState(WeatherPageEvent event) async* {
    if (event is LoadCachedWeatherEvent) {
      yield* _mapLoadCachedWeatherToState(event);
    } else if (event is InitWeatherNetEvent) {
      yield* _mapInitWeatherEventToState(event);
    }
  }

  Stream<WeatherPageState> _mapLoadCachedWeatherToState(
      LoadCachedWeatherEvent event) async* {
    final CityElement cityElement = event.cityElement;
    final String key = cityElement.key;

    //加载天气数据缓存¬
    if (state is LoadCachedWeatherDataState) {
      //加载缓存的天气数据
      final Map<String, dynamic>? result =
          await _sqliteManager.queryCityWeather(key);

      if (result != null) {
        final timeStamp = result[SqliteManager.timeStampKey];
        final span = DateTimeUtils.getTimeSpanByNow(timeStamp);

        LogUtil.d(
            "WeatherPageBloc.._mapLoadCachedWeatherToState()..缓存时间间隔:$span~");

        if (span < 5) {
          final WeatherRT weatherNow =
              WeatherRT.fromJson(result[SqliteManager.weatherRTKey]);

          final WeatherAir weatherAir =
              WeatherAir.fromJson(result[SqliteManager.weatherAirKey]);

          final WeatherHour weatherHour =
              WeatherHour.fromJson(result[SqliteManager.weatherHourKey]);

          final WeatherDaily weatherDaily =
              WeatherDaily.fromJson(result[SqliteManager.weatherDailyKey]);

          final WeatherIndices weatherIndices =
              WeatherIndices.fromJson(result[SqliteManager.weatherIndicesKey]);

          if (weatherNow != null && weatherNow.code == "200") {
            yield RequestWeatherSuccessState(weatherNow, weatherAir,
                weatherDaily, weatherIndices, weatherHour);
          } else {
            yield StartReuestWeatherState();
            add(InitWeatherNetEvent(cityElement));
          }
        }
      } else {
        yield StartReuestWeatherState();
        add(InitWeatherNetEvent(cityElement));
      }
    }
  }

  Stream<WeatherPageState> _mapInitWeatherEventToState(
      InitWeatherNetEvent event) async* {
    ///TODO:缓存某城市天气数据，key = lat&lon;

    final CityElement cityElement = event.cityElement;
    final String key = cityElement.key;
    final latitude = cityElement.latitude;
    final longitude = cityElement.longitude;

    LogUtil.d(
        "WeatherPageBloc.._mapInitWeatherEventToState()..当前查询城市:${cityElement.name}~");

    if (state is StartReuestWeatherState) {
      //获取天气信息
      final WeatherRT weatherNow =
          await _weatherRemoteRepository.requestWeatherNow(longitude, latitude);

      //实时空气质量
      final WeatherAir weatherAir =
          await _weatherRemoteRepository.requestAirNow(longitude, latitude);

      //24H
      final WeatherHour weatherHour =
          await _weatherRemoteRepository.requestWeather24H(longitude, latitude);

      //7D
      final WeatherDaily weatherDaily =
          await _weatherRemoteRepository.requestWether7D(longitude, latitude);

      //当天天气指数
      final WeatherIndices weatherIndices =
          await _weatherRemoteRepository.requestIndices1D(longitude, latitude);

      //极端天气预警
      // final WeatherWarning warning =
      //     await _weatherRemoteRepository.requestWarningNow(
      //         _baiduLocation!.longitude, _baiduLocation!.latitude);

      //空气质量预报
      // final AirDaily airDaily = await _weatherRemoteRepository.requestAir5D(
      //     _baiduLocation!.longitude, _baiduLocation!.latitude);

      //日出日落
      // final AstronomySun sun =
      //     await _weatherRemoteRepository.requestAstronomySun(
      //         _baiduLocation!.longitude, _baiduLocation!.latitude);

      //月升月落
      // final AstronomyMoon moon =
      //     await _weatherRemoteRepository.requestAstronomyMoon(
      //         _baiduLocation!.longitude, _baiduLocation!.latitude);

      if (weatherNow != null && weatherNow.code == "200") {
        yield RequestWeatherSuccessState(
            weatherNow, weatherAir, weatherDaily, weatherIndices, weatherHour);
        _sqliteManager.updateCityWeather(key, weatherNow, weatherAir,
            weatherHour, weatherDaily, weatherIndices);
      } else {
        yield const RequestWeatherFailedState(WeatherError.connectionError);
      }
    }
  }

  @override
  void onTransition(Transition<WeatherPageEvent, WeatherPageState> transition) {
    super.onTransition(transition);
    LogUtil.d("天气tab页面..onTransition:$transition");
  }
}
