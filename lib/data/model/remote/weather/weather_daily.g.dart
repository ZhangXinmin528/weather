// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDaily _$WeatherDailyFromJson(Map<String, dynamic> json) {
  return WeatherDaily(
    json['code'] as String,
    json['updateTime'] as String,
    json['fxLink'] as String,
    (json['daily'] as List<dynamic>)
        .map((e) => Daily.fromJson(e as Map<String, dynamic>))
        .toList(),
    Refer.fromJson(json['refer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherDailyToJson(WeatherDaily instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'daily': instance.daily.map((e) => e.toJson()).toList(),
      'refer': instance.refer.toJson(),
    };

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
    json['fxDate'] as String,
    json['sunrise'] as String,
    json['sunset'] as String,
    json['moonrise'] as String,
    json['moonset'] as String,
    json['moonPhase'] as String,
    json['tempMax'] as String,
    json['tempMin'] as String,
    json['iconDay'] as String,
    json['textDay'] as String,
    json['iconNight'] as String,
    json['textNight'] as String,
    json['wind360Day'] as String,
    json['windDirDay'] as String,
    json['windScaleDay'] as String,
    json['windSpeedDay'] as String,
    json['wind360Night'] as String,
    json['windDirNight'] as String,
    json['windScaleNight'] as String,
    json['windSpeedNight'] as String,
    json['humidity'] as String,
    json['precip'] as String,
    json['pressure'] as String,
    json['vis'] as String,
    json['cloud'] as String,
    json['uvIndex'] as String,
  );
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'fxDate': instance.fxDate,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'moonPhase': instance.moonPhase,
      'tempMax': instance.tempMax,
      'tempMin': instance.tempMin,
      'iconDay': instance.iconDay,
      'textDay': instance.textDay,
      'iconNight': instance.iconNight,
      'textNight': instance.textNight,
      'wind360Day': instance.wind360Day,
      'windDirDay': instance.windDirDay,
      'windScaleDay': instance.windScaleDay,
      'windSpeedDay': instance.windSpeedDay,
      'wind360Night': instance.wind360Night,
      'windDirNight': instance.windDirNight,
      'windScaleNight': instance.windScaleNight,
      'windSpeedNight': instance.windSpeedNight,
      'humidity': instance.humidity,
      'precip': instance.precip,
      'pressure': instance.pressure,
      'vis': instance.vis,
      'cloud': instance.cloud,
      'uvIndex': instance.uvIndex,
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
