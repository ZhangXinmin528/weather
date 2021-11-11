// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirDaily _$AirDailyFromJson(Map<String, dynamic> json) {
  return AirDaily(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    (json['daily'] as List<dynamic>)
        .map((e) => Daily.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AirDailyToJson(AirDaily instance) => <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'daily': instance.daily.map((e) => e.toJson()).toList(),
      'refer': instance.refer.toJson(),
    };

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
    json['fxDate'] as String,
    json['aqi'] as String,
    json['level'] as String,
    json['category'] as String,
    json['primary'] as String,
  );
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'fxDate': instance.fxDate,
      'aqi': instance.aqi,
      'level': instance.level,
      'category': instance.category,
      'primary': instance.primary,
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
