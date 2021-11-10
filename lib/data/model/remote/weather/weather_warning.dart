import 'package:json_annotation/json_annotation.dart';

part 'weather_warning.g.dart';

@JsonSerializable()
class WeatherWarning {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'warning')
  List<Warning> warning;

  @JsonKey(name: 'refer')
  Refer refer;

  WeatherWarning(
    this.code,
    this.updateTime,
    this.fxLink,
    this.warning,
    this.refer,
  );

  factory WeatherWarning.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherWarningFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$WeatherWarningToJson(this);
  }
}

@JsonSerializable()
class Warning {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'pubTime')
  String pubTime;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'startTime')
  String startTime;

  @JsonKey(name: 'endTime')
  String endTime;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'text')
  String text;

  Warning(
    this.id,
    this.pubTime,
    this.title,
    this.startTime,
    this.endTime,
    this.status,
    this.level,
    this.type,
    this.text,
  );

  factory Warning.fromJson(Map<String, dynamic> srcJson) =>
      _$WarningFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$WarningToJson(this);
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
