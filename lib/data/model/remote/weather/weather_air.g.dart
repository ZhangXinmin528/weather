// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_air.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAir _$WeatherAirFromJson(Map<String, dynamic> json) {
  return WeatherAir(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    Now.fromJson(json['now'] as Map<String, dynamic>),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherAirToJson(WeatherAir instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'now': instance.now,
      'refer': instance.refer,
    };

Now _$NowFromJson(Map<String, dynamic> json) {
  return Now(
    json['pubTime'] as String,
    json['aqi'] as String,
    json['level'] as String,
    json['category'] as String,
    json['primary'] as String,
    json['pm10'] as String,
    json['pm2p5'] as String,
    json['no2'] as String,
    json['so2'] as String,
    json['co'] as String,
    json['o3'] as String,
  );
}

Map<String, dynamic> _$NowToJson(Now instance) => <String, dynamic>{
      'pubTime': instance.pubTime,
      'aqi': instance.aqi,
      'level': instance.level,
      'category': instance.category,
      'primary': instance.primary,
      'pm10': instance.pm10,
      'pm2p5': instance.pm2p5,
      'no2': instance.no2,
      'so2': instance.so2,
      'co': instance.co,
      'o3': instance.o3,
    };

Station _$StationFromJson(Map<String, dynamic> json) {
  return Station(
    json['pubTime'] as String,
    json['name'] as String,
    json['id'] as String,
    json['aqi'] as String,
    json['level'] as String,
    json['category'] as String,
    json['primary'] as String,
    json['pm10'] as String,
    json['pm2p5'] as String,
    json['no2'] as String,
    json['so2'] as String,
    json['co'] as String,
    json['o3'] as String,
  );
}

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'pubTime': instance.pubTime,
      'name': instance.name,
      'id': instance.id,
      'aqi': instance.aqi,
      'level': instance.level,
      'category': instance.category,
      'primary': instance.primary,
      'pm10': instance.pm10,
      'pm2p5': instance.pm2p5,
      'no2': instance.no2,
      'so2': instance.so2,
      'co': instance.co,
      'o3': instance.o3,
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
