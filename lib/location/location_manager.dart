import 'package:geolocator/geolocator.dart';
import 'package:weather/location/location_provider.dart';
import 'package:weather/utils/log_utils.dart';

class LocationManager {
  final LocationProvider _locationProvider;
  Position? _lastPosition;

  LocationManager(this._locationProvider);

  ///获取最近的定位信息；
  Future<Position?> getLocation() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }

      _lastPosition = await _locationProvider.providerPosition();
      return _lastPosition;
    } catch (exception, stackTrace) {
      LogUtil.e("Exception occured:$exception $stackTrace");
      return null;
    }
  }

  ///能否定位
  Future<bool> isLocationEnable() {
    return _locationProvider.isLocationEnabled();
  }

  ///检查定位权限
  Future<LocationPermission> checkLocationPermission() {
    return _locationProvider.checkLocationPermissions();
  }

  ///请求定位权限
  Future<LocationPermission> requestLocationPermission() {
    return _locationProvider.requestLocationPermission();
  }
}
