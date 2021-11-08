import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather/weather_page_event.dart';
import 'package:weather/bloc/weather/weather_page_state.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherPageBloc extends Bloc<WeatherPageEvent, WeatherPageState> {
  final WeatherRemoteRepository _weatherRemoteRepository;

  WeatherPageBloc(this._weatherRemoteRepository)
      : super(StartReuestWeatherState());

  @override
  Stream<WeatherPageState> mapEventToState(WeatherPageEvent event) async* {
    if (event is InitWeatherPageEvent) {
      yield* _mapInitWeatherEventToState(event, state);
    }
  }

  Stream<WeatherPageState> _mapInitWeatherEventToState(
      InitWeatherPageEvent event, WeatherPageState state) async* {
    ///TODO:缓存某城市天气数据，key = lat&lon;
    LogUtil.d(
        "WeatherPageBloc.._mapInitWeatherEventToState()..city:${event.cityElement.name}~");
    final latitude = event.cityElement.latitude;
    final longitude = event.cityElement.longitude;
    //开始请求天气数据
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

      if (weatherNow != null) {
        if (weatherNow.code != "200") {
          yield RequestWeatherFailedState(WeatherError.data_not_available);
        } else {
          yield RequestWeatherSuccessState(weatherNow, weatherAir, weatherDaily,
              weatherIndices, weatherHour);
        }
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
