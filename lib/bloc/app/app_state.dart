import 'package:equatable/equatable.dart';
import 'package:weather/data/model/internal/unit.dart';

class AppState extends Equatable {
  final Unit unit;

  AppState(this.unit);

  @override
  List<Object?> get props => [unit];
}
