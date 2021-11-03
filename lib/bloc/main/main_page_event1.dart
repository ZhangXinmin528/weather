import 'package:equatable/equatable.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object?> get props => [];
}

///开始定位
class RequestLocationEvent extends MainPageEvent {}

///定位改变
class LocationChangedEvent extends MainPageEvent {}

///天气信息展示
class WeatherDataLoadedMainEvent extends MainPageEvent {}

