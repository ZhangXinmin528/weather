// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_indices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherIndices _$WeatherIndicesFromJson(Map<String, dynamic> json) {
  return WeatherIndices(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    (json['daily'] as List<dynamic>)
        .map((e) => Daily.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherIndicesToJson(WeatherIndices instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'daily': instance.daily,
      'refer': instance.refer,
    };

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
    json['date'] as String,
    json['type'] as String,
    json['name'] as String,
    json['level'] as String,
    json['category'] as String,
    json['text'] as String,
  );
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'date': instance.date,
      'type': instance.type,
      'name': instance.name,
      'level': instance.level,
      'category': instance.category,
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
