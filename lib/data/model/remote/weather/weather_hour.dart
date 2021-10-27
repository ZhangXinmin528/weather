import 'package:json_annotation/json_annotation.dart';

part 'weather_hour.g.dart';

@JsonSerializable()
class WeatherHour {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'hourly')
  List<Hourly> hourly;

  @JsonKey(name: 'refer')
  Refer refer;

  WeatherHour(
    this.code,
    this.updateTime,
    this.fxLink,
    this.hourly,
    this.refer,
  );

  factory WeatherHour.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherHourFromJson(srcJson);
}

@JsonSerializable()
class Hourly {
  @JsonKey(name: 'fxTime')
  String fxTime;

  @JsonKey(name: 'temp')
  String temp;

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

  @JsonKey(name: 'pop')
  String pop;

  @JsonKey(name: 'precip')
  String precip;

  @JsonKey(name: 'pressure')
  String pressure;

  @JsonKey(name: 'cloud')
  String cloud;

  @JsonKey(name: 'dew')
  String dew;

  Hourly(
    this.fxTime,
    this.temp,
    this.icon,
    this.text,
    this.wind360,
    this.windDir,
    this.windScale,
    this.windSpeed,
    this.humidity,
    this.pop,
    this.precip,
    this.pressure,
    this.cloud,
    this.dew,
  );

  factory Hourly.fromJson(Map<String, dynamic> srcJson) =>
      _$HourlyFromJson(srcJson);
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
