import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/repository/local/storage_manager.dart';

class AppLocalRepository {
  final StorageManager _storageManager;

  AppLocalRepository(this._storageManager);

  ///单位
  Future<Unit> getSavedUnit() async {
    return _storageManager.getUnit();
  }

  void saveUnit(Unit unit) {
    _storageManager.saveUnit(unit);
  }

  ///定位信息
  Future<BaiduLocation?> getLocation() async {
    return _storageManager.getLocation();
  }

  void saveLocation(String location) {
    _storageManager.saveLocation(location);
  }

  ///更新时间
  Future<int> getLastRefreshTime() {
    return _storageManager.getLastRefreshTime();
  }

  void saveLastRefreshTime(int lastRefreshTime) {
    _storageManager.saveLastRefreshTime(lastRefreshTime);
  }
}
