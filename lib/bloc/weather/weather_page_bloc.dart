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

    //加载天气数据缓存
    if (state is LoadCachedWeatherDataState) {
      //加载缓存的天气数据
      final Map? result = await _sqliteManager.queryCityWeather(key);
      LogUtil.d("WeatherPageBloc.._mapLoadCachedWeatherToState()..缓存:$result~");
      if (result != null) {
        final timeStamp = result[SqliteManager.timeStampKey];
        final span = DateTimeUtils.getTimeSpanByNow(timeStamp);

        LogUtil.d(
            "WeatherPageBloc.._mapLoadCachedWeatherToState()..缓存时间间隔:$span~");

        if (span < 5) {
          final WeatherRT weatherNow = WeatherRT.fromJson(
              result[SqliteManager.weatherRTKey] as Map<String, dynamic>);

          final WeatherAir weatherAir = WeatherAir.fromJson(
              result[SqliteManager.weatherAirKey] as Map<String, dynamic>);

          final WeatherHour weatherHour = WeatherHour.fromJson(
              result[SqliteManager.weatherHourKey] as Map<String, dynamic>);

          final WeatherDaily weatherDaily = WeatherDaily.fromJson(
              result[SqliteManager.weatherDailyKey] as Map<String, dynamic>);

          final WeatherIndices weatherIndices = WeatherIndices.fromJson(
              result[SqliteManager.weatherIndicesKey] as Map<String, dynamic>);

          if (weatherNow != null && weatherNow.code == "200") {
            yield RequestWeatherSuccessState(weatherNow, weatherAir,
                weatherDaily, weatherIndices, weatherHour);
          } else {
            //缓存失效，更新缓存
            yield StartRequestWeatherState();
            add(InitWeatherNetEvent(cityElement, true));
          }
        } else {
          yield StartRequestWeatherState();
          add(InitWeatherNetEvent(cityElement, true));
        }
      } else {
        yield StartRequestWeatherState();
        add(InitWeatherNetEvent(cityElement, false));
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

    if (state is StartRequestWeatherState) {
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
        if (event.hasCached) {
          final index = await _sqliteManager.updateCityWeather(key, weatherNow,
              weatherAir, weatherHour, weatherDaily, weatherIndices);
          LogUtil.d("天气tab页面..更新数据库:$index");
        } else {
          final index = await _sqliteManager.insertCityWeather(key, weatherNow,
              weatherAir, weatherHour, weatherDaily, weatherIndices);
          LogUtil.d("天气tab页面..插入数据库:$index");
        }

        yield RequestWeatherSuccessState(
            weatherNow, weatherAir, weatherDaily, weatherIndices, weatherHour);
      } else {
        yield RequestWeatherFailedState(WeatherError.connectionError);
      }
    }
  }

  @override
  void onTransition(Transition<WeatherPageEvent, WeatherPageState> transition) {
    super.onTransition(transition);
    LogUtil.d("天气tab页面..onTransition:$transition");
  }
}
