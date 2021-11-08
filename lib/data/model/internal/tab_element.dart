///用于构建tab
class TabElement {
  final String title;

  final CityElement cityElement;

  TabElement(this.title, this.cityElement);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map();
    jsonMap['title'] = this.title;
    jsonMap['cityElement'] = this.cityElement;
    return jsonMap;
  }

  factory TabElement.fromJson(Map<String, dynamic> json) {
    return TabElement(json['title'] as String,
        CityElement.fromJson(json['cityElement'] as Map<String, dynamic>));
  }
}

///用于构建Tab中的城市数据
class CityElement {
  //缓存数据的key
  String key;
  String name;
  double latitude;
  double longitude;
  String? city;
  String? country;

  CityElement(
      {required this.key,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.city,
      this.country});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map();
    jsonMap['key'] = this.key;
    jsonMap['name'] = this.name;
    jsonMap['latitude'] = this.latitude;
    jsonMap['longitude'] = this.longitude;
    jsonMap['city'] = this.city;
    jsonMap['country'] = this.country;
    return jsonMap;
  }

  factory CityElement.fromJson(Map<String, dynamic> json) {
    return CityElement(
      key: json['key'] as String,
      name: json['name'] as String,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
