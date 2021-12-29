import 'package:flutter/services.dart';
import 'package:weather/utils/log_utils.dart';

///checkUpgrade hasNewVersion
class ChannelHelper {
  static const UPGRADE_CHANNEL = "upgrade_channel";
  static const UPGRADE_CHECK = "checkUpgrade";
  static const UPGRADE_NEWVERSION = "hasNewVersion";

  //更新
  static var _upgradePlatform;

  factory ChannelHelper() {
    return _instance;
  }

  static late final ChannelHelper _instance = ChannelHelper._internal();

  ChannelHelper._internal() {
    _upgradePlatform = MethodChannel(UPGRADE_CHANNEL);
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
