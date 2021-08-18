import 'package:geolocator/geolocator.dart';

class LocationProvider {

  ///是否能定位
  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  ///检查定位权限
  Future<LocationPermission> checkLocationPermissions() async {
    return Geolocator.checkPermission();
  }

  ///请求定位权限
  Future<LocationPermission> requestLocationPermission() async {
    return Geolocator.requestPermission();
  }

  ///获取当前定位数据
  Future<Position> providerPosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
