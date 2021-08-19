import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/navigation/navigation_event.dart';
import 'package:weather/bloc/navigation/navigation_state.dart';
import 'package:weather/data/model/internal/navigation_route.dart';
import 'package:weather/navigation/navigation_provider.dart';
import 'package:weather/resources/config/navigation_path.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final NavigationProvider _navigationProvider;
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigationBloc(this._navigationProvider, this._navigatorKey)
      : super(NavigationState(NavigationRoute.mainScreen));

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is MainScreenNavigationEvent) {
      _navigationTo(NavigationPath.mainPagePath);
      yield NavigationState(NavigationRoute.mainScreen);
    }

    ///未完待续。。。
  }

  void _navigationTo(String path, {RouteSettings? routeSettings}) {
    _navigationProvider.navigationToPath(
      path,
      _navigatorKey,
      routeSettings: routeSettings,
    );
  }
}
