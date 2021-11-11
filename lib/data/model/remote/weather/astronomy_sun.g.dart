// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'astronomy_sun.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AstronomySun _$AstronomySunFromJson(Map<String, dynamic> json) {
  return AstronomySun(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    json['sunrise'] as String,
    json['sunset'] as String,
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AstronomySunToJson(AstronomySun instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'refer': instance.refer.toJson(),
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
