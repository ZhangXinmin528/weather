import 'package:json_annotation/json_annotation.dart';

part 'air_daily.g.dart';

@JsonSerializable()
class AirDaily {
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

  AirDaily(
    this.code,
    this.updateTime,
    this.fxLink,
    this.daily,
    this.refer,
  );

  factory AirDaily.fromJson(Map<String, dynamic> srcJson) =>
      _$AirDailyFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$AirDailyToJson(this);
  }
}

@JsonSerializable()
class Daily {
  @JsonKey(name: 'fxDate')
  String fxDate;

  @JsonKey(name: 'aqi')
  String aqi;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'primary')
  String primary;

  Daily(
    this.fxDate,
    this.aqi,
    this.level,
    this.category,
    this.primary,
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
