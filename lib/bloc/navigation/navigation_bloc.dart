import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/bloc/navigation/navigation_state.dart';

class NavigaionBloc extends Bloc<NavigationEvent,NavigationState>{

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}