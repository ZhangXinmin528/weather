import 'package:json_annotation/json_annotation.dart';

part 'astronomy_sun.g.dart';

@JsonSerializable()
class AstronomySun {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'fxLink')
  String fxLink;

  @JsonKey(name: 'sunrise')
  String sunrise;

  @JsonKey(name: 'sunset')
  String sunset;

  @JsonKey(name: 'refer')
  Refer refer;

  AstronomySun(
    this.code,
    this.updateTime,
    this.fxLink,
    this.sunrise,
    this.sunset,
    this.refer,
  );

  factory AstronomySun.fromJson(Map<String, dynamic> srcJson) =>
      _$AstronomySunFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$AstronomySunToJson(this);
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
