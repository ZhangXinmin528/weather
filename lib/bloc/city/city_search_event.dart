import 'package:equatable/equatable.dart';

class CitySearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///热门城市
class TopCityEvent extends CitySearchEvent {}

///搜索城市
class CityLookupEvent extends CitySearchEvent {
  final String keyWord;

  CityLookupEvent(this.keyWord);

  @override
  List<Object?> get props => [keyWord];
}
