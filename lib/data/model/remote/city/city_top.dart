import 'package:json_annotation/json_annotation.dart';

part 'city_top.g.dart';

@JsonSerializable()
class CityTop extends Object {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'topCityList')
  List<TopCityList> topCityList;

  @JsonKey(name: 'refer')
  Refer refer;

  CityTop(
    this.code,
    this.topCityList,
    this.refer,
  );

  factory CityTop.fromJson(Map<String, dynamic> srcJson) =>
      _$CityTopFromJson(srcJson);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map();
    if (this.code.isNotEmpty) {
      map['code'] = this.code;
    }
    if (this.topCityList.isNotEmpty) {
      map['topCityList'] = this.topCityList.map((e) => e.toJson()).toList();
    }
    if (this.refer != null) {
      map['refer'] = this.refer.toJson();
    }

    return map;
  }
}

@JsonSerializable()
class TopCityList extends Object {
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

  TopCityList(
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

  factory TopCityList.fromJson(Map<String, dynamic> srcJson) =>
      _$TopCityListFromJson(srcJson);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['name'] = this.name;
    map['id'] = this.id;
    map['lat'] = this.lat;
    map['lon'] = this.lon;
    map['adm2'] = this.adm2;
    map['adm1'] = this.adm1;
    map['country'] = this.country;
    map['tz'] = this.tz;
    map['utcOffset'] = this.utcOffset;
    map['isDst'] = this.isDst;
    map['type'] = this.type;
    map['rank'] = this.rank;
    map['fxLink'] = this.fxLink;
    return map;
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
    Map<String, dynamic> map = Map();
    map['sources'] = this.sources.map((e) => e).toList();
    map['license'] = this.license.map((e) => e).toList();
    return map;
  }
}
