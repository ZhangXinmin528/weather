import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/navigation_route.dart';

class NavigationState extends Equatable {
  final NavigationRoute _navigationRoute;

  NavigationState(this._navigationRoute);

  @override
  // TODO: implement props
  List<Object?> get props => [_navigationRoute];
}
