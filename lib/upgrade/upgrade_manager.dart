import 'package:path_provider/path_provider.dart';
import 'package:weather/utils/log_utils.dart';

class UpgradeManager {
  factory UpgradeManager() {
    return _instance;
  }

  UpgradeManager._internal();

  static late final UpgradeManager _instance = UpgradeManager._internal();

  void getCommonDirectory() async {
    final download = await getDownloadsDirectory();
    final library = await getLibraryDirectory();
    final temp = await getTemporaryDirectory();
    final document = await getApplicationDocumentsDirectory();
    final support = await getApplicationSupportDirectory();
    final cache = await getExternalCacheDirectories();
    final storage = await getExternalStorageDirectory();

    LogUtil.d(
        "getCommonDirectory..download:${download?.path}..library:${library.path}"
        "..temp:${temp.path}..document:${document.path}..support:${support.path}"
        "..cache:${cache.toString()}..storage:${storage?.path}");
  }
}
