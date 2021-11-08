import 'package:equatable/equatable.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object?> get props => [];
}

///加载已添加城市列表
class LoadCityListEvent extends MainPageEvent {}

///开始定位
class RequestLocationEvent extends MainPageEvent {}

///定位改变
class LocationChangedEvent extends MainPageEvent {}

///添加天气信息展示
class AddWeatherTabToMainEvent extends MainPageEvent {}
