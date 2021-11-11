// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherWarning _$WeatherWarningFromJson(Map<String, dynamic> json) {
  return WeatherWarning(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    (json['warning'] as List<dynamic>)
        .map((e) => Warning.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherWarningToJson(WeatherWarning instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'warning': instance.warning.map((e) => e.toJson()).toList(),
      'refer': instance.refer.toJson(),
    };

Warning _$WarningFromJson(Map<String, dynamic> json) {
  return Warning(
    json['id'] as String,
    json['pubTime'] as String,
    json['title'] as String,
    json['startTime'] as String,
    json['endTime'] as String,
    json['status'] as String,
    json['level'] as String,
    json['type'] as String,
    json['text'] as String,
  );
}

Map<String, dynamic> _$WarningToJson(Warning instance) => <String, dynamic>{
      'id': instance.id,
      'pubTime': instance.pubTime,
      'title': instance.title,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'level': instance.level,
      'type': instance.type,
      'text': instance.text,
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
