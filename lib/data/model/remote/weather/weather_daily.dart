import 'package:json_annotation/json_annotation.dart';

part 'weather_daily.g.dart';

@JsonSerializable()
class WeatherDaily {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'daily')
  List<Daily> daily;

  @JsonKey(name: 'refer')
  Refer refer;

  WeatherDaily(
    this.code,
    this.updateTime,
    this.fxLink,
    this.daily,
    this.refer,
  );

  factory WeatherDaily.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherDailyFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$WeatherDailyToJson(this);
  }
}

@JsonSerializable()
class Daily {
  @JsonKey(name: 'fxDate')
  String fxDate;

  @JsonKey(name: 'sunrise')
  String sunrise;

  @JsonKey(name: 'sunset')
  String sunset;

  @JsonKey(name: 'moonrise')
  String moonrise;

  @JsonKey(name: 'moonset')
  String moonset;

  @JsonKey(name: 'moonPhase')
  String moonPhase;

  @JsonKey(name: 'tempMax')
  String tempMax;

  @JsonKey(name: 'tempMin')
  String tempMin;

  @JsonKey(name: 'iconDay')
  String iconDay;

  @JsonKey(name: 'textDay')
  String textDay;

  @JsonKey(name: 'iconNight')
  String iconNight;

  @JsonKey(name: 'textNight')
  String textNight;

  @JsonKey(name: 'wind360Day')
  String wind360Day;

  @JsonKey(name: 'windDirDay')
  String windDirDay;

  @JsonKey(name: 'windScaleDay')
  String windScaleDay;

  @JsonKey(name: 'windSpeedDay')
  String windSpeedDay;

  @JsonKey(name: 'wind360Night')
  String wind360Night;

  @JsonKey(name: 'windDirNight')
  String windDirNight;

  @JsonKey(name: 'windScaleNight')
  String windScaleNight;

  @JsonKey(name: 'windSpeedNight')
  String windSpeedNight;

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

  @JsonKey(name: 'uvIndex')
  String uvIndex;

  Daily(
    this.fxDate,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.tempMax,
    this.tempMin,
    this.iconDay,
    this.textDay,
    this.iconNight,
    this.textNight,
    this.wind360Day,
    this.windDirDay,
    this.windScaleDay,
    this.windSpeedDay,
    this.wind360Night,
    this.windDirNight,
    this.windScaleNight,
    this.windSpeedNight,
    this.humidity,
    this.precip,
    this.pressure,
    this.vis,
    this.cloud,
    this.uvIndex,
  );

  factory Daily.fromJson(Map<String, dynamic> srcJson) =>
      _$DailyFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$DailyToJson(this);
  }
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

  Map<String, dynamic> toJson() {
    return _$ReferToJson(this);
  }
}
