import 'package:package_info_plus/package_info_plus.dart';

class AppUtil {
  ///get app name
  static Future<String> getAppName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  ///get package name
  static Future<String> getPackageName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  ///get version name
  static Future<String> getVersionName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  ///get build number
  static Future<String> getBuildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
