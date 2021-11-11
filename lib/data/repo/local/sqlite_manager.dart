import 'dart:convert' as convert;

import 'package:sqflite/sqflite.dart';
import 'package:weather/data/model/remote/weather/air_daily.dart';
import 'package:weather/data/model/remote/weather/astronomy_moon.dart';
import 'package:weather/data/model/remote/weather/astronomy_sun.dart';
import 'package:weather/data/model/remote/weather/weather_air.dart';
import 'package:weather/data/model/remote/weather/weather_daily.dart';
import 'package:weather/data/model/remote/weather/weather_hour.dart';
import 'package:weather/data/model/remote/weather/weather_indices.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';
import 'package:weather/utils/datetime_utils.dart';

class SqliteManager {
  Database? _database;

  static final String _dbName = "weather_city.db";
  static final String _defaultTable = "weatherCities";
  static final String keyLoc = "key";
  static final String timeStampKey = "timeStamp";

  //获取天气信息
  static final String weatherRTKey = "weatherRT";

  //实时空气质量
  static final String weatherAirKey = "weatherAir";

  //24H
  static final String weatherHourKey = "weatherHour";

  //7D
  static final String weatherDailyKey = "weatherDaily";

  //当天天气指数
  static final String weatherIndicesKey = "weatherIndices";

  //极端天气预警
  static final String weatherWarningKey = "weatherWarning";

  //空气质量预报
  static final String airDailyKey = "airDaily";

  //日出日落
  static final String astronomySunKey = "astronomySun";

  //月升月落
  static final String astronomyMoonKey = "astronomyMoon";

  SqliteManager._privateConstructor();

  static final SqliteManager INSTANCE = SqliteManager._privateConstructor();

  Future<Database> get getDatabase async {
    if (_database == null) {
      _database = await _openDataBase(_dbName);
    }
    return _database!;
  }

  ///打开数据库
  Future<Database> _openDataBase(String dbName) async {
    return await openDatabase(dbName, version: 1,
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE $_defaultTable '
          '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' $keyLoc TEXT NOT NULL,'
          ' $timeStampKey TEXT NOT NULL,'
          ' $weatherRTKey TEXT NOT NULL,'
          ' $weatherAirKey TEXT NOT NULL,'
          ' $weatherHourKey TEXT NOT NULL,'
          ' $weatherDailyKey TEXT NOT NULL,'
          ' $weatherIndicesKey TEXT NOT NULL,'
          ' $weatherWarningKey TEXT,'
          ' $airDailyKey TEXT,'
          ' $astronomySunKey TEXT,'
          ' $astronomyMoonKey TEXT)');
    });
  }

  ///新增某城市天气数据
  Future<int?> insertCityWeather(
      String key,
      WeatherRT weatherRT,
      WeatherAir weatherAir,
      WeatherHour weatherHour,
      WeatherDaily weatherDaily,
      WeatherIndices weatherIndices,
      {WeatherWarning? weatherWarning,
      AirDaily? airDaily,
      AstronomySun? astronomySun,
      AstronomyMoon? astronomyMoon}) async {
    Map<String, dynamic> map = Map();
    map[keyLoc] = key;
    map[timeStampKey] = DateTimeUtils.getFormatedNowTimeString();
    map[weatherRTKey] = convert.jsonEncode(weatherRT.toJson());
    map[weatherAirKey] = convert.jsonEncode(weatherAir.toJson());
    map[weatherHourKey] = convert.jsonEncode(weatherHour.toJson());
    map[weatherDailyKey] = convert.jsonEncode(weatherDaily.toJson());
    map[weatherIndicesKey] = convert.jsonEncode(weatherIndices.toJson());
    map[weatherWarningKey] = convert.jsonEncode(weatherWarning?.toJson());
    map[airDailyKey] = convert.jsonEncode(airDaily?.toJson());
    map[astronomySunKey] = convert.jsonEncode(astronomyMoon?.toJson());
    map[astronomyMoonKey] = convert.jsonEncode(astronomyMoon?.toJson());

    _database = await getDatabase;
    return await _database?.insert(_defaultTable, map);
  }

  ///删除某城市天气数据
  Future<int?> deleteCityWeather(String key) async {
    _database = await getDatabase;
    return await _database
        ?.delete(_defaultTable, where: '$keyLoc=?', whereArgs: [key]);
  }

  ///更新某个城市天气
  Future<int?> updateCityWeather(
      String key,
      WeatherRT weatherRT,
      WeatherAir weatherAir,
      WeatherHour weatherHour,
      WeatherDaily weatherDaily,
      WeatherIndices weatherIndices,
      {WeatherWarning? weatherWarning,
      AirDaily? airDaily,
      AstronomySun? astronomySun,
      AstronomyMoon? astronomyMoon}) async {
    Map<String, dynamic> map = Map();
    map[keyLoc] = key;
    map[timeStampKey] = DateTimeUtils.getFormatedNowTimeString();
    map[weatherRTKey] = convert.jsonEncode(weatherRT.toJson());
    map[weatherAirKey] = convert.jsonEncode(weatherAir.toJson());
    map[weatherHourKey] = convert.jsonEncode(weatherHour.toJson());
    map[weatherDailyKey] = convert.jsonEncode(weatherDaily.toJson());
    map[weatherIndicesKey] = convert.jsonEncode(weatherIndices.toJson());
    map[weatherWarningKey] = convert.jsonEncode(weatherWarning?.toJson());
    map[airDailyKey] = convert.jsonEncode(airDaily?.toJson());
    map[astronomySunKey] = convert.jsonEncode(astronomyMoon?.toJson());
    map[astronomyMoonKey] = convert.jsonEncode(astronomyMoon?.toJson());

    _database = await getDatabase;
    return await _database
        ?.update(_defaultTable, map, where: '$keyLoc=?', whereArgs: [key]);
  }

  ///获取指定城市天气数据
  Future<Map<String, dynamic>?> queryCityWeather(String key) async {
    _database = await getDatabase;
    final List<Map<String, dynamic>>? list =
        await _database?.query(_defaultTable,
            columns: [
              keyLoc,
              timeStampKey,
              weatherRTKey,
              weatherAirKey,
              weatherHourKey,
              weatherDailyKey,
              weatherIndicesKey
            ],
            where: '$keyLoc = ?',
            whereArgs: [key]);

    if (list != null && list.isNotEmpty) {
      final map = list.last;
      Map<String, dynamic> weather = Map();
      weather[keyLoc] = map[keyLoc];
      weather[timeStampKey] = map[timeStampKey];
      weather[weatherRTKey] = convert.jsonDecode(map[weatherRTKey] ?? "");
      weather[weatherAirKey] = convert.jsonDecode(map[weatherAirKey] ?? "");
      weather[weatherHourKey] = convert.jsonDecode(map[weatherHourKey] ?? "");
      weather[weatherDailyKey] = convert.jsonDecode(map[weatherDailyKey] ?? "");
      weather[weatherIndicesKey] =
          convert.jsonDecode(map[weatherIndicesKey] ?? "");
      return weather;
    } else {
      return null;
    }
  }

  ///获取指定城市实时天气数据
  Future<Map<String, dynamic>?> queryCityWeatherNow(String key) async {
    _database = await getDatabase;
    final List<Map<String, dynamic>>? list =
        await _database?.query(_defaultTable,
            columns: [
              keyLoc,
              timeStampKey,
              weatherRTKey,
            ],
            where: '$keyLoc = ?',
            whereArgs: [key]);

    if (list != null && list.isNotEmpty) {
      final map = list.last;
      Map<String, dynamic> weather = Map();
      weather[keyLoc] = map[keyLoc];
      weather[timeStampKey] = map[timeStampKey];
      weather[weatherRTKey] = convert.jsonDecode(map[weatherRTKey] ?? "");
      return weather;
    } else {
      return null;
    }
  }

  ///查询最后一条数据
  Future<Map?> queryLast() async {
    _database = await getDatabase;
    final List<Map>? list = await _database?.query(_defaultTable);
    if (list != null && list.isNotEmpty) {
      return list.last;
    } else {
      return null;
    }
  }

  ///清空表中数据
  Future<void> deleteAll() async {
    _database = await getDatabase;
    await _database?.execute('delete from $_defaultTable');
  }
}
