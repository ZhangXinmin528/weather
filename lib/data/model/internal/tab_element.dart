///用于构建tab
class TabElement {
  final String title;

  final CityElement cityElement;

  int? positon;

  //温度
  final String? temp;

  //天气描述
  final String? text;

  //天气icon
  final String? icon;

  TabElement(this.title, this.cityElement,
      {this.positon, this.temp, this.text, this.icon});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map();
    jsonMap['title'] = this.title;
    jsonMap['position'] = this.positon;
    jsonMap['temp'] = this.temp ?? "";
    jsonMap['text'] = this.text ?? "";
    jsonMap['icon'] = this.icon ?? "";
    jsonMap['cityElement'] = this.cityElement;
    return jsonMap;
  }

  factory TabElement.fromJson(Map<String, dynamic> json) {
    return TabElement(json['title'] as String,
        CityElement.fromJson(json['cityElement'] as Map<String, dynamic>),
        positon: (json['position'] ?? 0) as int,
        temp: json['temp'] as String,
        text: json['text'] as String,
        icon: json['icon'] as String);
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
  String? locTime;

  CityElement(
      {required this.key,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.city,
      this.country,
      this.locTime});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = Map();
    jsonMap['key'] = this.key;
    jsonMap['name'] = this.name;
    jsonMap['latitude'] = this.latitude;
    jsonMap['longitude'] = this.longitude;
    jsonMap['city'] = this.city;
    jsonMap['country'] = this.country;
    jsonMap['locTime'] = this.locTime;
    return jsonMap;
  }

  factory CityElement.fromJson(Map<String, dynamic> json) {
    return CityElement(
      key: json['key'] as String,
      name: json['name'] as String,
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'] ?? "",
      country: json['country'] ?? "",
      locTime: json['locTime'] ?? "",
    );
  }
}
