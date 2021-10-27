import 'package:json_annotation/json_annotation.dart';

part 'weather_now.g.dart';

///实时天气信息
@JsonSerializable()
class WeatherRT {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'now')
  Now now;

  @JsonKey(name: 'refer')
  Refer refer;

  WeatherRT(
    this.code,
    this.updateTime,
    this.fxLink,
    this.now,
    this.refer,
  );

  factory WeatherRT.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherRTFromJson(srcJson);
}

@JsonSerializable()
class Now {
  @JsonKey(name: 'obsTime')
  String obsTime;

  @JsonKey(name: 'temp')
  String temp;

  @JsonKey(name: 'feelsLike')
  String feelsLike;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'wind360')
  String wind360;

  @JsonKey(name: 'windDir')
  String windDir;

  @JsonKey(name: 'windScale')
  String windScale;

  @JsonKey(name: 'windSpeed')
  String windSpeed;

  @JsonKey(name: 'humidity')
  String humidity;

  @JsonKey(name: 'precip')
  String precip;

  @JsonKey(name: 'pressure')
  String pressure;

  @JsonKey(name: 'vis')
  String vis;

  @JsonKey(name: 'cloud')
  String cloud;

  @JsonKey(name: 'dew')
  String dew;

  Now(
    this.obsTime,
    this.temp,
    this.feelsLike,
    this.icon,
    this.text,
    this.wind360,
    this.windDir,
    this.windScale,
    this.windSpeed,
    this.humidity,
    this.precip,
    this.pressure,
    this.vis,
    this.cloud,
    this.dew,
  );

  factory Now.fromJson(Map<String, dynamic> srcJson) => _$NowFromJson(srcJson);
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
