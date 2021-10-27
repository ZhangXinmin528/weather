import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/repository/local/storage_manager.dart';

class ApplicationLocalRepository {
  final StorageManager _storageManager;

  ApplicationLocalRepository(this._storageManager);

  //单位
  Future<Unit> getSavedUnit() async {
    return _storageManager.getUnit();
  }

  void saveUnit(Unit unit) {
    _storageManager.saveUnit(unit);
  }

  Future<int> getSavedRefreshTime() async {
    return _storageManager.getRefreshTime();
  }

  void saveRefreshTime(int refreshTime) {
    _storageManager.saveRefreshTime(refreshTime);
  }

  //更新时间
  Future<int> getLastRefreshTime() {
    return _storageManager.getLastRefreshTime();
  }

  void saveLastRefreshTime(int lastRefreshTime) {
    _storageManager.saveLastRefreshTime(lastRefreshTime);
  }
}
