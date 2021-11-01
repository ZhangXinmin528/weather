import 'dart:convert' as convert;

import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/model/remote/city/city_top.dart';
import 'package:weather/resources/config/ids.dart';
import 'package:weather/utils/datetime_utils.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/shared_preferences_utils.dart';

class StorageManager {
  final SharedPreferencesUtils _spUtils;

  StorageManager(this._spUtils);

  ///单位
  Future<Unit> getUnit() async {
    try {
      final int? unit = await _spUtils.getInt(Ids.storageUnitKey);
      if (unit == null) {
        return Unit.metric;
      } else {
        if (unit == 0) {
          return Unit.metric;
        } else {
          return Unit.imperial;
        }
      }
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return Unit.metric;
    }
  }

  Future<bool> saveUnit(Unit unit) async {
    try {
      LogUtil.d("Store unit $unit");
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      final result = await _spUtils.setInt(Ids.storageUnitKey, unitValue);
      LogUtil.d("Saved with result: $result");

      return result;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  ///定位信息
  Future<bool> saveLocation(String location) async {
    try {
      LogUtil.d("Save location: $location");
      final result = await _spUtils.setString(Ids.storageLocationKey, location);
      LogUtil.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<BaiduLocation?> getLocation() async {
    BaiduLocation? location;
    try {
      String? result = await _spUtils.getString(Ids.storageLocationKey);
      if (result != null && result.isNotEmpty) {
        location = BaiduLocation.fromMap(result);
      }
      return location;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return location;
    }
  }

  ///更新时间
  Future<bool> saveLastRefreshTime(int lastRefreshTime) async {
    try {
      LogUtil.d("Save refresh time: $lastRefreshTime");
      final result =
          await _spUtils.setInt(Ids.storageLastRefreshTimeKey, lastRefreshTime);
      LogUtil.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<int> getLastRefreshTime() async {
    try {
      int? lastRefreshTime =
          await _spUtils.getInt(Ids.storageLastRefreshTimeKey);
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeUtils.getNowTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return DateTimeUtils.getNowTime();
    }
  }

  ///热门城市
  Future<bool> saveTopCities(String cities) async {
    try {
      LogUtil.d("Save top cities: $cities");
      final result = await _spUtils.setString(Ids.storageTopCitiesKey, cities);
      LogUtil.d("Saved top cities: $result");
      return result;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<CityTop?> getTopCities() async {
    CityTop? cityTop;
    try {
      String? topCities = await _spUtils.getString(Ids.storageTopCitiesKey);
      if (topCities != null && topCities.isNotEmpty) {
        cityTop = CityTop.fromJson(convert.jsonDecode(topCities));
      }
      return cityTop;
    } catch (exc, stackTrace) {
      LogUtil.e("Exception: $exc stack trace: $stackTrace");
      return cityTop;
    }
  }
}
