import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/main/main_screen_event.dart';
import 'package:weather/bloc/main/main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent,MainScreenState>{
  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) {
  }

}