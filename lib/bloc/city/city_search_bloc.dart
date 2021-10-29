import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_search_event.dart';
import 'package:weather/bloc/city/city_search_state.dart';
import 'package:weather/data/repository/local/app_local_repository.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final AppLocalRepository _appLocalRepo;

  CitySearchBloc(this._appLocalRepo) : super(GetTopCitiesDataState());

  @override
  Stream<CitySearchState> mapEventToState(CitySearchEvent event) async* {
    if (event is TopCityEvent) {
      yield* _mapTopCityToState(state);
    }
  }

  ///热门城市
  Stream<CitySearchState> _mapTopCityToState(CitySearchState state) async* {
    if (state is GetTopCitiesDataState) {

    }
  }
}
