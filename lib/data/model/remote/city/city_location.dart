import 'package:json_annotation/json_annotation.dart';

part 'city_location.g.dart';

@JsonSerializable()
class CityLocation extends Object {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'location')
  List<Location> location;

  @JsonKey(name: 'refer')
  Refer refer;

  CityLocation(
    this.code,
    this.location,
    this.refer,
  );

  factory CityLocation.fromJson(Map<String, dynamic> srcJson) =>
      _$CityLocationFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$CityLocationToJson(this);
  }
}

@JsonSerializable()
class Location extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'lat')
  String lat;

  @JsonKey(name: 'lon')
  String lon;

  @JsonKey(name: 'adm2')
  String adm2;

  @JsonKey(name: 'adm1')
  String adm1;

  @JsonKey(name: 'country')
  String country;

  @JsonKey(name: 'tz')
  String tz;

  @JsonKey(name: 'utcOffset')
  String utcOffset;

  @JsonKey(name: 'isDst')
  String isDst;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'rank')
  String rank;

  @JsonKey(name: 'fxLink')
  String fxLink;

  Location(
    this.name,
    this.id,
    this.lat,
    this.lon,
    this.adm2,
    this.adm1,
    this.country,
    this.tz,
    this.utcOffset,
    this.isDst,
    this.type,
    this.rank,
    this.fxLink,
  );

  factory Location.fromJson(Map<String, dynamic> srcJson) =>
      _$LocationFromJson(srcJson);

  Map<String, dynamic> toJson() {
    return _$LocationToJson(this);
  }
}

@JsonSerializable()
class Refer extends Object {
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
