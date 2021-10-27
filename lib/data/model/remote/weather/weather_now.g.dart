// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_now.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherRT _$WeatherRTFromJson(Map<String, dynamic> json) {
  return WeatherRT(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    Now.fromJson(json['now'] as Map<String, dynamic>),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherRTToJson(WeatherRT instance) => <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'now': instance.now,
      'refer': instance.refer,
    };

Now _$NowFromJson(Map<String, dynamic> json) {
  return Now(
    json['obsTime'] as String,
    json['temp'] as String,
    json['feelsLike'] as String,
    json['icon'] as String,
    json['text'] as String,
    json['wind360'] as String,
    json['windDir'] as String,
    json['windScale'] as String,
    json['windSpeed'] as String,
    json['humidity'] as String,
    json['precip'] as String,
    json['pressure'] as String,
    json['vis'] as String,
    json['cloud'] as String,
    json['dew'] as String,
  );
}

Map<String, dynamic> _$NowToJson(Now instance) => <String, dynamic>{
      'obsTime': instance.obsTime,
      'temp': instance.temp,
      'feelsLike': instance.feelsLike,
      'icon': instance.icon,
      'text': instance.text,
      'wind360': instance.wind360,
      'windDir': instance.windDir,
      'windScale': instance.windScale,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
      'precip': instance.precip,
      'pressure': instance.pressure,
      'vis': instance.vis,
      'cloud': instance.cloud,
      'dew': instance.dew,
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
