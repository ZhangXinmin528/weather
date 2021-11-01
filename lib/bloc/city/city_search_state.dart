import 'package:equatable/equatable.dart';
import 'package:weather/data/model/remote/city/city_location.dart';
import 'package:weather/data/model/remote/city/city_top.dart';

class CitySearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

///获取热门城市数据
class TopCitiesInitDataState extends CitySearchState {}

///热门城市获取成功
class TopCitiesSuccessState extends CitySearchState {
  final List<TopCityList> cityList;

  TopCitiesSuccessState(this.cityList);

  @override
  List<Object?> get props => [cityList];
}

///热门城市获取失败
class TopCitiesFailedState extends CitySearchState {}

///城市搜索成功
class CityLookupSuccessState extends CitySearchState {
  final CityLocation cityLocation;

  CityLookupSuccessState(this.cityLocation);

  @override
  List<Object?> get props => [cityLocation];
}

///城市搜索失败
class CityLookupFailedState extends CitySearchState {}
