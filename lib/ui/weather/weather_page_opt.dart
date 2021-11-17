import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/remote/weather/weather_now.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';
import 'package:weather/utils/icon_utils.dart';

class WeatherPageOpt extends StatefulWidget {
  final CityElement _cityElement;

  WeatherPageOpt(this._cityElement);

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageOptState(_cityElement);
  }
}

class _WeatherPageOptState extends State<WeatherPageOpt> {
  final WeatherRemoteRepo _weatherRemoteRepo = WeatherRemoteRepo();
  final StreamController<WeatherRT> _weather = StreamController();
  final CityElement _cityElement;

  _WeatherPageOptState(this._cityElement);

  @override
  void initState() {
    super.initState();

    requestWeatherData(_cityElement);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _weather.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final WeatherRT weatherRT = snapshot.data as WeatherRT;
            return _buildWeatherDescAndIcon(weatherRT);
          } else {
            return SizedBox();
          }
        });
  }

  ///temp
  Widget _buildTempWidget(String temp) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(left: 16.0, top: 60.0),
      child: Text(
        temp,
        key: const Key("main_screen_temp_now"),
        style: TextStyle(fontSize: 60, fontWeight: FontWeight.normal),
      ),
    );
  }

  ///weather icon and desc
  Widget _buildWeatherDescAndIcon(WeatherRT weather) {
    final weatherNow = weather.now;
    return Container(
      key: const Key("main_screen_desc_and_icon"),
      margin: EdgeInsets.only(
        left: 16.0,
        top: 6,
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconUtils.getWeatherNowIcon(weatherNow.icon),
          Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Text(
              weatherNow.text,
              key: const Key("main_screen_weathernow_text"),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestWeatherData(CityElement element) async {
    final latitude = element.latitude;
    final longitude = element.longitude;

    _weatherRemoteRepo.requestWeatherNow(longitude, latitude,
        onResponse: (map) {
      final WeatherRT weatherRT = WeatherRT.fromJson(map!);
      _weather.add(weatherRT);
    });
  }

  @override
  void dispose() {
    _weather.close();
    super.dispose();
  }
}
