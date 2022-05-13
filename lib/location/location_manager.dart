import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:weather/utils/log_utils.dart';

class LocationManager {
  late StreamSubscription<Map<String, Object>?>? _locationListener;
  late LocationFlutterPlugin _myLocPlugin;
  bool _suc = false;

  factory LocationManager() {
    return _instance;
  }

  static late final LocationManager _instance = LocationManager._internal();

  ///私有构造器
  LocationManager._internal() {
    _myLocPlugin = new LocationFlutterPlugin();
  }

  //==================================单次定位=================================//
  /// 开始单次定位
  Future<void> startSingleLocation() async {
    _singleLocationAction();
    if (Platform.isIOS) {
      _suc = await _myLocPlugin
          .singleLocation({'isReGeocode': true, 'isNetworkState': true});
      print('开始单次定位：$_suc');
    } else if (Platform.isAndroid) {
      _suc = await _myLocPlugin.startLocation();
    }
  }

  void _singleLocationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    final Map iosMap = initSingleIOSOptions().getMap();
    final Map androidMap = initSingleAndroidOptions().getMap();

    _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);
    print('设置定位参数：$iosMap');
  }

  /// 设置地图参数
  BaiduLocationAndroidOption initSingleAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        coorType: 'bd09ll',
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        locationPurpose: BMFLocationPurpose.sport,
        coordType: BMFLocationCoordType.bd09ll);
    return options;
  }

  BaiduLocationIOSOption initSingleIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
        desiredAccuracy: BMFDesiredAccuracy.best);
    return options;
  }

  void listenSingleLocationCallback(ValueChanged<BaiduLocation?> valueChanged) {
    ///单次定位时如果是安卓可以在内部进行判断调用连续定位
    if (Platform.isIOS) {
      ///接受定位回调
      _myLocPlugin.singleLocationCallback(callback: (BaiduLocation result) {
        try {
          valueChanged(result);
        } catch (exception) {
          valueChanged(null);
          print(exception);
        }
      });
    } else if (Platform.isAndroid) {
      ///接受定位回调
      _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
        LogUtil.d(
            "LocationManager..listenSingleLocationCallback回调了..result：${result.toString()}");
        try {
          valueChanged(result);
        } catch (exception) {
          valueChanged(null);
          stopLocation();
          print(exception);
        }
      });
    }
  }

  //==================================连续定位=================================//

  ///开始连续定位
  Future<void> startLocation() async {
    _locationAction();
    _suc = await _myLocPlugin.startLocation();
    print('开始连续定位：$_suc');
  }

  void _locationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();

    _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);
    print('设置定位参数：$iosMap');
  }

  /// 设置地图参数
  BaiduLocationAndroidOption _initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        coorType: 'bd09ll',
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: 4000,
        coordType: BMFLocationCoordType.bd09ll);
    return options;
  }

  BaiduLocationIOSOption _initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
        desiredAccuracy: BMFDesiredAccuracy.best,
        allowsBackgroundLocationUpdates: true,
        pausesLocationUpdatesAutomatically: false);
    return options;
  }

  ///停止连续定位
  void stopLocation() async {
    if (_myLocPlugin != null) {
      _suc = await _myLocPlugin.stopLocation();
      print('停止连续定位：$_suc');
    }
  }

  void listenLocationCallback(ValueChanged<BaiduLocation?> valueChanged) {
    ///接受定位回调
    _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      LogUtil.d(
          "LocationManager..listenLocationCallback回调了..result：${result.toString()}");
      try {
        valueChanged(result);
      } catch (exception) {
        valueChanged(null);
        print(exception);
      }
    });
  }
}
