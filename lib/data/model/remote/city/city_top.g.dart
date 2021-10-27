// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_top.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityTop _$CityTopFromJson(Map<String, dynamic> json) {
  return CityTop(
    json['code'] as String,
    (json['topCityList'] as List<dynamic>)
        .map((e) => TopCityList.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CityTopToJson(CityTop instance) => <String, dynamic>{
      'code': instance.code,
      'topCityList': instance.topCityList,
      'refer': instance.refer,
    };

TopCityList _$TopCityListFromJson(Map<String, dynamic> json) {
  return TopCityList(
    json['name'] as String,
    json['id'] as String,
    json['lat'] as String,
    json['lon'] as String,
    json['adm2'] as String,
    json['adm1'] as String,
    json['country'] as String,
    json['tz'] as String,
    json['utcOffset'] as String,
    json['isDst'] as String,
    json['type'] as String,
    json['rank'] as String,
    json['fxLink'] as String,
  );
}

Map<String, dynamic> _$TopCityListToJson(TopCityList instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'lat': instance.lat,
      'lon': instance.lon,
      'adm2': instance.adm2,
      'adm1': instance.adm1,
      'country': instance.country,
      'tz': instance.tz,
      'utcOffset': instance.utcOffset,
      'isDst': instance.isDst,
      'type': instance.type,
      'rank': instance.rank,
      'fxLink': instance.fxLink,
    };

Refer _$ReferFromJson(Map<String, dynamic> json) {
  return Refer(
    (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
    (json['license'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ReferToJson(Refer instance) => <String, dynamic>{
      'sources': instance.sources,
      'license': instance.license,
    };
