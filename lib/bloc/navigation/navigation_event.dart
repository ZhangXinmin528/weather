import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/model/internal/weather_forecast_holder.dart';

class NavigationEvent extends Equatable{

  @override
  List<Object?> get props => [];

}

///主页面
class MainScreenNavigationEvent extends NavigationEvent {}

///天气信息页面
class ForecastScreenNavigationEvent extends NavigationEvent {
  final WeatherForecastHolder holder;

  ForecastScreenNavigationEvent(this.holder);
}

///关于页面
class AboutScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  AboutScreenNavigationEvent(this.startGradientColors);
}

///设置页面
class SettingsScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  SettingsScreenNavigationEvent(this.startGradientColors);
}