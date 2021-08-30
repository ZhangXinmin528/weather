// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_hour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherHour _$WeatherHourFromJson(Map<String, dynamic> json) {
  return WeatherHour(
    json['code'] as String,
    json['updateTimwee'] as String,
    json['fxLink'] as String,
    (json['hourly'] as List<dynamic>)
        .map((e) => Hourly.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherHourToJson(WeatherHour instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTimwee': instance.updateTime,
      'fxLink': instance.fxLink,
      'hourly': instance.hourly,
      'refer': instance.refer,
    };

Hourly _$HourlyFromJson(Map<String, dynamic> json) {
  return Hourly(
    json['fxTime'] as String,
    json['temp'] as String,
    json['icon'] as String,
    json['text'] as String,
    json['wind360'] as String,
    json['windDir'] as String,
    json['windScale'] as String,
    json['windSpeed'] as String,
    json['humidity'] as String,
    json['pop'] as String,
    json['precip'] as String,
    json['pressure'] as String,
    json['cloud'] as String,
    json['dew'] as String,
  );
}

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
      'fxTime': instance.fxTime,
      'temp': instance.temp,
      'icon': instance.icon,
      'text': instance.text,
      'wind360': instance.wind360,
      'windDir': instance.windDir,
      'windScale': instance.windScale,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
      'pop': instance.pop,
      'precip': instance.precip,
      'pressure': instance.pressure,
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
