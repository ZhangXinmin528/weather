import 'package:equatable/equatable.dart';

class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object?> get props => [];
}

class LocationCheckMainEvent extends MainScreenEvent {}

class LoadWeatherMainEvent extends MainScreenEvent {}
