import 'package:flutter/services.dart';
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

  //更新
  static var _upgradePlatform;

  //NOTIFICATION
  static var _notifiWarningPlatform;

  factory ChannelHelper() {
    return _instance;
  }

  static late final ChannelHelper _instance = ChannelHelper._internal();

  ChannelHelper._internal() {
    _upgradePlatform = MethodChannel(UPGRADE_CHANNEL);
    _notifiWarningPlatform = MethodChannel(NOTIFI_WARNING_CHANNEL);
  }

  ///发送预警天气信息
  Future<String> notifiWeatherWarnings(String args) async {
    String result = "";
    try {
      result = await _notifiWarningPlatform.invokeMethod<String>(
          NOTIFI_WEATHER_WARNING, {"$NOTIFI_WARNING_ARGS": args});
    } on PlatformException catch (e) {
      LogUtil.e(e.toString());
    }
    return result;
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
