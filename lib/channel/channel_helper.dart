import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/utils/log_utils.dart';

///checkUpgrade hasNewVersion
class ChannelHelper {
  //检查更新
  static const UPGRADE_CHANNEL = "upgrade_channel";
  static const UPGRADE_CHECK = "checkUpgrade";
  static const UPGRADE_NEWVERSION = "hasNewVersion";

  //天气预警通知
  static const NOTIFI_WARNING_CHANNEL = "notification_weather";
  static const NOTIFI_WEATHER_WARNING = "notifiWeatherWarning";
  static const NOTIFI_WARNING_ARGS = "notifi_weather_warning_args";
  static const NOTIFI_SELECTED = "notificationSelected";

  //更新
  static var _upgradePlatform;

  //NOTIFICATION
  MethodChannel? _notifiWarningPlatform;
  ValueChanged<List<Warning>>? _warningCallback;

  factory ChannelHelper() {
    return _instance;
  }

  static late final ChannelHelper _instance = ChannelHelper._internal();

  ChannelHelper._internal() {
    _upgradePlatform = MethodChannel(UPGRADE_CHANNEL);
    _notifiWarningPlatform = MethodChannel(NOTIFI_WARNING_CHANNEL);
    _notifiWarningPlatform?.setMethodCallHandler((call) async {
      switch (call.method) {
        case NOTIFI_SELECTED:
          return notificationSelected(call);
      }
    });
  }

  ///发送预警天气信息
  Future<String?> notifiWeatherWarnings(
      String args, ValueChanged<List<Warning>>? callback) async {
    String? result = "";
    try {
      result = await _notifiWarningPlatform?.invokeMethod<String>(
          NOTIFI_WEATHER_WARNING, {"$NOTIFI_WARNING_ARGS": args});
      this._warningCallback = callback;
    } on PlatformException catch (e) {
      LogUtil.e(e.toString());
    }
    return result;
  }

  Future notificationSelected(MethodCall call) async {
    final args = call.arguments;
    if (args != null) {
      try {
        final srcJson = convert.jsonDecode(args);
        final WeatherWarning weatherWarning = WeatherWarning.fromJson(srcJson);
        if (weatherWarning != null) {
          final warningList = weatherWarning.warning;
          if (warningList != null && warningList.isNotEmpty) {
            if (_warningCallback != null) {
              _warningCallback!(warningList);
            }
          }
        }
      } on Exception catch (e) {
        LogUtil.d("notificationSelected..exception:${e.toString()}");
      }
    }
  }

  ///检查新版本
  Future<bool> hasNewVersion() async {
    bool state = false;
    try {
      state = await _upgradePlatform.invokeMethod<bool>(UPGRADE_NEWVERSION);
    } on PlatformException catch (e) {
      LogUtil.e(e.toString());
    }
    return state;
  }

  ///检查更新
  Future checkUpgrade() async {
    try {
      await _upgradePlatform.invokeMethod(UPGRADE_CHECK);
    } on PlatformException catch (e) {
      LogUtil.e(e.toString());
    }
  }
}
