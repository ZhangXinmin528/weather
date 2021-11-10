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

  ///打开数据库
  Future _openDataBase(String dbName) async {
    _database =
        await openDatabase(dbName, version: 1, onCreate: (db, version) async {
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
          ' $astronomyMoonKey TEXT,');
    });
  }

  Future<Database> get getDatabase async {
    if (_database == null) {
      _database = await _openDataBase(_dbName);
    }
    return _database!;
  }

  ///新增某城市天气数据
  Future<int> insertCityWeather(
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
    map[weatherRTKey] = weatherRT.toJson();
    map[weatherAirKey] = weatherAir.toJson();
    map[weatherHourKey] = weatherHour.toJson();
    map[weatherDailyKey] = weatherDaily.toJson();
    map[weatherIndicesKey] = weatherIndices.toJson();
    map[weatherWarningKey] = weatherWarning?.toJson();
    map[airDailyKey] = airDaily?.toJson();
    map[astronomySunKey] = astronomyMoon?.toJson();
    map[astronomyMoonKey] = astronomyMoon?.toJson();

    final Database db = await INSTANCE.getDatabase;
    return await db.insert(_defaultTable, map);
  }

  ///删除某城市天气数据
  Future<int> deleteCityWeather(String key) async {
    return await _database!
        .delete(_defaultTable, where: '$keyLoc=?', whereArgs: [key]);
  }

  ///更新某个城市天气
  Future<int> updateCityWeather(
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
    map[weatherRTKey] = weatherRT.toJson();
    map[weatherAirKey] = weatherAir.toJson();
    map[weatherHourKey] = weatherHour.toJson();
    map[weatherDailyKey] = weatherDaily.toJson();
    map[weatherIndicesKey] = weatherIndices.toJson();
    map[weatherWarningKey] = weatherWarning?.toJson();
    map[airDailyKey] = airDaily?.toJson();
    map[astronomySunKey] = astronomyMoon?.toJson();
    map[astronomyMoonKey] = astronomyMoon?.toJson();

    final Database db = await INSTANCE.getDatabase;
    return await db
        .update(_defaultTable, map, where: '$keyLoc=?', whereArgs: [key]);
  }

  ///获取指定城市天气数据
  Future<Map<String, dynamic>?> queryCityWeather(String key) async {
    final Database db = await INSTANCE.getDatabase;
    final List<Map<String, dynamic>> list = await db.query(
        _defaultTable,
        columns: [keyLoc],
        where: '$keyLoc=?',
        whereArgs: [key]);

    if (list != null && list.isNotEmpty) {
      return list[0];
    } else {
      return null;
    }
  }

  ///清空表中数据
  Future<void> deleteAll() async {
    final Database db = await INSTANCE.getDatabase;
    await db.execute('delete from $_defaultTable');
  }
}
