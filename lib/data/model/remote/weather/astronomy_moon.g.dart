// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'astronomy_moon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AstronomyMoon _$AstronomyMoonFromJson(Map<String, dynamic> json) {
  return AstronomyMoon(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    json['moonrise'] as String,
    json['moonset'] as String,
    (json['moonPhase'] as List<dynamic>)
        .map((e) => MoonPhase.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AstronomyMoonToJson(AstronomyMoon instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'moonPhase': instance.moonPhase,
      'refer': instance.refer,
    };

MoonPhase _$MoonPhaseFromJson(Map<String, dynamic> json) {
  return MoonPhase(
    json['fxTime'] as String,
    json['value'] as String,
    json['name'] as String,
    json['illumination'] as String,
  );
}

Map<String, dynamic> _$MoonPhaseToJson(MoonPhase instance) => <String, dynamic>{
      'fxTime': instance.fxTime,
      'value': instance.value,
      'name': instance.name,
      'illumination': instance.illumination,
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
