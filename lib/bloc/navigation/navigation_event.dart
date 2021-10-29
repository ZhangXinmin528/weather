import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///主页面
class MainPageNavigationEvent extends NavigationEvent {}

///天气信息页面
class ForecastScreenNavigationEvent extends NavigationEvent {}

///关于页面
class AboutScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  AboutScreenNavigationEvent(this.startGradientColors);
}

///城市管理
class CityManagePageNavigationEvent extends NavigationEvent {}

///城市搜索
class CitySearchPageNavigationEvent extends NavigationEvent {}

///设置页面
class SettingsPageNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  SettingsPageNavigationEvent(this.startGradientColors);
}
