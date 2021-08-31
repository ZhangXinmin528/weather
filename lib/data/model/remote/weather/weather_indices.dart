import 'package:json_annotation/json_annotation.dart';

part 'weather_indices.g.dart';

@JsonSerializable()
class WeatherIndices {
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

  WeatherIndices(
    this.code,
    this.updateTime,
    this.fxLink,
    this.daily,
    this.refer,
  );

  factory WeatherIndices.fromJson(Map<String, dynamic> srcJson) =>
      _$WeatherIndicesFromJson(srcJson);
}

@JsonSerializable()
class Daily {
  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'text')
  String text;

  Daily(
    this.date,
    this.type,
    this.name,
    this.level,
    this.category,
    this.text,
  );

  factory Daily.fromJson(Map<String, dynamic> srcJson) =>
      _$DailyFromJson(srcJson);
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
