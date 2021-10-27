import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/city/city_manage_event.dart';
import 'package:weather/bloc/city/city_manage_state.dart';

class CityManageBloc extends Bloc<CityManageEvent,CityManageState>{

  CityManageBloc(CityManageState initialState) : super(initialState);

  @override
  Stream<CityManageState> mapEventToState(CityManageEvent event) {
    // TODO: implement mapEventToState
    return super.mapEventToState(event);
  }
}