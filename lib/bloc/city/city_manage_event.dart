import 'package:equatable/equatable.dart';

abstract class CityManageEvent extends Equatable {}

///初始化城市列表
class InitCityListEvent extends CityManageEvent {
  @override
  List<Object?> get props => [];
}

///城市列表发生变化
class SaveChangedEvent extends CityManageEvent {
  @override
  List<Object?> get props => [];
}
