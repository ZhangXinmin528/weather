import 'package:path_provider/path_provider.dart';
import 'package:weather/utils/log_utils.dart';

class UpgradeManager {
  String? _apkPath;

  factory UpgradeManager() {
    return _instance;
  }

  UpgradeManager._internal() {}

  static late final UpgradeManager _instance = UpgradeManager._internal();

  void getCommonDirectory() async {
    //getCacheDir:/data/user/0/com.zxm.coding.weather/cache
    final temp = await getTemporaryDirectory();
    //getDataDirectory:/data/user/0/com.zxm.coding.weather/app_flutter
    final document = await getApplicationDocumentsDirectory();
    //getFilesDir:/data/user/0/com.zxm.coding.weather/files
    final support = await getApplicationSupportDirectory();
    //getExternalCacheDir:/storage/emulated/0/Android/data/com.zxm.coding.weather/cache
    final cache = await getExternalCacheDirectories();
    //getExternalFilesDir:/storage/emulated/0/Android/data/com.zxm.coding.weather/files
    final storage = await getExternalStorageDirectory();

    LogUtil.d(
        "getCommonDirectory..temp:${temp.path}\n..document:${document.path}\n..support:${support.path}\n"
        "..cache:${cache.toString()}\n..storage:${storage?.path}\n");
  }
}
