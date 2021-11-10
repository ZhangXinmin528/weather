import 'package:json_annotation/json_annotation.dart';

part 'astronomy_moon.g.dart';

@JsonSerializable()
class AstronomyMoon {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'moonrise')
  String moonrise;

  @JsonKey(name: 'moonset')
  String moonset;

  @JsonKey(name: 'moonPhase')
  List<MoonPhase> moonPhase;

  @JsonKey(name: 'refer')
  Refer refer;

  AstronomyMoon(
    this.code,
    this.updateTime,
    this.fxLink,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.refer,
  );

  factory AstronomyMoon.fromJson(Map<String, dynamic> srcJson) =>
      _$AstronomyMoonFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$AstronomyMoonToJson(this);
  }
}

@JsonSerializable()
class MoonPhase {
  @JsonKey(name: 'fxTime')
  String fxTime;

  @JsonKey(name: 'value')
  String value;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'illumination')
  String illumination;

  MoonPhase(
    this.fxTime,
    this.value,
    this.name,
    this.illumination,
  );

  factory MoonPhase.fromJson(Map<String, dynamic> srcJson) =>
      _$MoonPhaseFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$MoonPhaseToJson(this);
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
