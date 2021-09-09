import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object?> get props => [];
}

///开始定位
class StartLocationEvent extends MainScreenEvent {}

///定位改变
class LocationChangedEvent extends MainScreenEvent {}

///天气信息展示
class WeatherDataLoadedMainEvent extends MainScreenEvent {}
