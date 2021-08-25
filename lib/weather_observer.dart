import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/location/location_manager.dart';
import 'package:weather/utils/log_utils.dart';

class WeatherObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    // LogUtil.d("WeatherObserver..$bloc..$change");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {}

  @override
  void onClose(BlocBase bloc) {
    LogUtil.d("WeatherObserver..$bloc");
    //终止定位
    LocationManager().stopLocation();
  }
}
