import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_manage_event.dart';
import 'package:weather/bloc/city/city_manage_state.dart';
import 'package:weather/data/model/internal/tab_element.dart';
import 'package:weather/data/model/internal/weather_error.dart';
import 'package:weather/data/repo/local/app_local_repo.dart';
import 'package:weather/data/repo/local/sqlite_manager.dart';
import 'package:weather/utils/log_utils.dart';

class CityManageBloc extends Bloc<CityManageEvent, CityManageState> {
  final AppLocalRepo _appLocalRepo;


  CityManageBloc(this._appLocalRepo) : super(InitCityListState());

  @override
  Stream<CityManageState> mapEventToState(CityManageEvent event) async* {
    if (event is InitCityListEvent) {
      yield* _mapInitCityListToState(state);
    } else if (event is SaveChangedEvent) {
      yield* _mapSaveChangedToState(state);
    }
  }

  Stream<CityManageState> _mapInitCityListToState(
      CityManageState state) async* {
    if (state is InitCityListState) {
      final List<TabElement>? tabs = await _appLocalRepo.getCityList();
      if (tabs != null && tabs.isNotEmpty) {
        yield CityListSuccessState(tabs);
        LogUtil.d("CityManageBloc..city list:${tabs[0].title}");
      } else {
        yield CityListFailedState(WeatherError.data_not_available);
      }
    }
  }

  Stream<CityManageState> _mapSaveChangedToState(CityManageState state) async* {
    if (state is SaveCityChangedState) {
      final List<TabElement>? tabList = state.tabList;
      if (tabList != null && tabList.isNotEmpty) {
        LogUtil.d(
            "CityManageBloc..save changed city list size:${tabList.length}");
        _appLocalRepo.saveCityList(tabList);
        add(InitCityListEvent());
        yield InitCityListState();
      }
    }
  }
}
