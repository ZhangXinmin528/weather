import 'package:flutter_bmflocation/flutter_baidu_location.dart';

class Coordinate {
  final double? lat;
  final double? long;

  Coordinate(this.lat, this.long);

  Coordinate.fromJson(Map<String, dynamic> json)
      : lat = json["lat"] as double?,
        long = json["long"] as double?;

  Coordinate.fromBaiduLocation(BaiduLocation position)
      : lat = position.latitude,
        long = position.longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "lat": lat,
        "long": long,
      };

  @override
  String toString() {
    return 'GeoPosition{lat: $lat, long: $long}';
  }
}
