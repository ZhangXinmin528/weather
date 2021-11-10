import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/model/remote/city/city_top.dart';
import 'package:weather/data/repo/local/sp_manager.dart';

class AppLocalRepo {
  final SPManager _spManager;

  AppLocalRepo(this._spManager);

  ///单位
  Future<Unit> getSavedUnit() async {
    return _spManager.getUnit();
  }

  void saveUnit(Unit unit) {
    _spManager.saveUnit(unit);
  }

  ///定位信息
  Future<BaiduLocation?> getLocation() async {
    return _spManager.getLocation();
  }

  void saveLocation(String location) {
    _spManager.saveLocation(location);
  }

  ///定位保存时间
  Future<String?> getLocationTime() async {
    return _spManager.getLocationTime();
  }

  void saveLocationTime() {
    _spManager.saveLocationTime();
  }

  ///更新时间
  Future<int> getLastRefreshTime() {
    return _spManager.getLastRefreshTime();
  }

  void saveLastRefreshTime(int lastRefreshTime) {
    _spManager.saveLastRefreshTime(lastRefreshTime);
  }

  ///热门城市
  void saveTopCities(String cities) {
    _spManager.saveTopCities(cities);
  }

  Future<CityTop?> getTopCities() async {
    return await _spManager.getTopCities();
  }

  ///管理城市列表
  void saveCityList(List<TabElement> cities) {
    _spManager.saveCityList(cities);
  }

  Future<List<TabElement>?> getCityList() async {
    return await _spManager.getCityList();
  }
}
