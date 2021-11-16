import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_search_event.dart';
import 'package:weather/bloc/city/city_search_state.dart';
import 'package:weather/data/model/remote/city/city_top.dart';
import 'package:weather/data/repo/local/app_local_repo.dart';
import 'package:weather/data/repo/remote/weather_remote_repo.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final AppLocalRepo _appLocalRepo;
  final WeatherRemoteRepo _weatherRemoteRepository = WeatherRemoteRepo.INSTANCE;

  CitySearchBloc(this._appLocalRepo) : super(TopCitiesInitDataState());

  @override
  Stream<CitySearchState> mapEventToState(CitySearchEvent event) async* {
    if (event is TopCityEvent) {
      yield* _mapTopCityToState(state);
    } else if (event is CityLookupEvent) {
      yield* _mapSearchCityToState(event);
    }
  }

  ///热门城市
  Stream<CitySearchState> _mapTopCityToState(CitySearchState state) async* {
    if (state is TopCitiesInitDataState) {
      CityTop? topCities;
      List<TopCityList> cityList;

      topCities = await _appLocalRepo.getTopCities();

      if (topCities == null) {
        topCities = await _weatherRemoteRepository.requestCityTop();
        final cities = convert.jsonEncode(topCities.toJson());
        _appLocalRepo.saveTopCities(cities);
      }

      if (topCities != null && topCities.code == "200") {
        cityList = topCities.topCityList;
        yield TopCitiesSuccessState(cityList);
      } else {
        yield TopCitiesFailedState();
      }
    }
  }

  ///城市搜索
  Stream<CitySearchState> _mapSearchCityToState(CityLookupEvent state) async* {
    final keyWord = state.keyWord;
    final cityLocation =
        await _weatherRemoteRepository.requestCityLookup(keyWord);

    if (cityLocation != null && cityLocation.code == "200") {
      yield CityLookupSuccessState(cityLocation);
    } else {
      yield CityLookupFailedState();
    }
  }
}
