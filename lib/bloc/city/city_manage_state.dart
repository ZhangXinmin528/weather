import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';

abstract class CityManageState extends Equatable {}

///初始化城市列表
class InitCityListState extends CityManageState {
  @override
  List<Object?> get props => [];
}

///城市数据加载成功
class CityListSuccessState extends CityManageState {
  final List<TabElement> tabList;

  CityListSuccessState(this.tabList);

  @override
  List<Object?> get props => [tabList];
}

///城市数据加载失败
class CityListFailedState extends CityManageState {
  final WeatherError error;

  CityListFailedState(this.error);

  @override
  List<Object?> get props => [error];
}

///保存城市列表调整
class SaveCityChangedState extends CityManageState {
  final List<TabElement> tabList;

  SaveCityChangedState(this.tabList);

  @override
  List<Object?> get props => [tabList];
}
