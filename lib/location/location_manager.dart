import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';

class LocationManager {
  late StreamSubscription<Map<String, Object>?>? _locationListener;
  late LocationFlutterPlugin _locationPlugin;

  factory LocationManager() {
    return _instance;
  }

  static late final LocationManager _instance = LocationManager._internal();

  ///私有构造器
  LocationManager._internal() {
    _locationPlugin = new LocationFlutterPlugin();
  }

  void startLocationOnce() {
    if (_locationPlugin != null) {
      _setLocOption(true);

      _locationPlugin.requestPermission();

      _locationPlugin.startLocation();
    }
  }

  ///开始定位
  void startLocation() {
    if (_locationPlugin != null) {
      _setLocOption(false);
      _locationPlugin.requestPermission();
      _locationPlugin.startLocation();
    }
  }

  void listenLocationCallback(ValueChanged<BaiduLocation?> valueChanged) {
    _locationListener = _locationPlugin
        .onResultCallback()
        .listen((Map<String, Object>? result) {
      try {
        final BaiduLocation location = BaiduLocation.fromMap(result);
        valueChanged(location);
      } catch (exception) {
        valueChanged(null);
        print(exception);
      }
    });
  }

  ///取消定位
  void _cancelLocation() {
    _locationListener?.cancel();
  }

  ///终止定位
  void stopLocation() {
    if (_locationPlugin != null) {
      _locationPlugin.stopLocation();
    }
  }

  ///移动端设置定位参数，包括
  void _setLocOption(bool isOnce) {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    if (isOnce) {
      androidOption.setScanspan(0); // 设置发起定位请求时间间隔
    } else {
      androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
    }

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    _locationPlugin?.prepareLoc(androidMap, iosMap);
  }
}
