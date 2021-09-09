import 'package:json_annotation/json_annotation.dart';

part 'weather_air.g.dart';

@JsonSerializable()
class WeatherAir {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'now')
  Now now;

  // @JsonKey(name: 'station')
  // List<Station> station;

  @JsonKey(name: 'refer')
  Refer refer;

  WeatherAir(
    this.code,
    this.updateTime,
    this.fxLink,
    this.now,
    /*this.station,*/ this.refer,
  );

  factory WeatherAir.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherAirFromJson(srcJson);
}

@JsonSerializable()
class Now {
  @JsonKey(name: 'pubTime')
  String pubTime;

  @JsonKey(name: 'aqi')
  String aqi;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'primary')
  String primary;

  @JsonKey(name: 'pm10')
  String pm10;

  @JsonKey(name: 'pm2p5')
  String pm2p5;

  @JsonKey(name: 'no2')
  String no2;

  @JsonKey(name: 'so2')
  String so2;

  @JsonKey(name: 'co')
  String co;

  @JsonKey(name: 'o3')
  String o3;

  Now(
    this.pubTime,
    this.aqi,
    this.level,
    this.category,
    this.primary,
    this.pm10,
    this.pm2p5,
    this.no2,
    this.so2,
    this.co,
    this.o3,
  );

  factory Now.fromJson(Map<String, dynamic> srcJson) => _$NowFromJson(srcJson);
}

@JsonSerializable()
class Station {
  @JsonKey(name: 'pubTime')
  String pubTime;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'aqi')
  String aqi;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'primary')
  String primary;

  @JsonKey(name: 'pm10')
  String pm10;

  @JsonKey(name: 'pm2p5')
  String pm2p5;

  @JsonKey(name: 'no2')
  String no2;

  @JsonKey(name: 'so2')
  String so2;

  @JsonKey(name: 'co')
  String co;

  @JsonKey(name: 'o3')
  String o3;

  Station(
    this.pubTime,
    this.name,
    this.id,
    this.aqi,
    this.level,
    this.category,
    this.primary,
    this.pm10,
    this.pm2p5,
    this.no2,
    this.so2,
    this.co,
    this.o3,
  );

  factory Station.fromJson(Map<String, dynamic> srcJson) =>
      _$StationFromJson(srcJson);
}

@JsonSerializable()
class Refer {
  @JsonKey(name: 'sources')
  List<String> sources;

  @JsonKey(name: 'license')
  List<String> license;

  Refer(
    this.sources,
    this.license,
  );

  factory Refer.fromJson(Map<String, dynamic> srcJson) =>
      _$ReferFromJson(srcJson);
}
