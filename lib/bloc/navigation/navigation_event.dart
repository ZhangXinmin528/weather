import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/model/internal/markdown.dart';
import 'package:weather/data/model/remote/weather/weather_warning.dart';

class NavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///主页面
class MainPageNavigationEvent extends NavigationEvent {}

///天气信息页面
class ForecastScreenNavigationEvent extends NavigationEvent {}

///天气预警详情页面
class WarningNavigationEvent extends NavigationEvent {
  final List<Warning> warningList;

  WarningNavigationEvent(this.warningList);

  @override
  List<Object?> get props => [warningList];
}

///关于页面
class AboutScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  AboutScreenNavigationEvent(this.startGradientColors);
}

///城市管理
class CityManagePageNavigationEvent extends NavigationEvent {}

///城市搜索
class CitySearchPageNavigationEvent extends NavigationEvent {}

///markdown
class MarkdownPageNavigationEvent extends NavigationEvent {
  final MarkdownFile markdownFile;

  MarkdownPageNavigationEvent(this.markdownFile);

  @override
  List<Object?> get props => [markdownFile];
}

///设置页面
class SettingsPageNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  SettingsPageNavigationEvent(this.startGradientColors);
}
