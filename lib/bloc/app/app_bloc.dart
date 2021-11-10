import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/app/app_event.dart';
import 'package:weather/bloc/app/app_state.dart';
import 'package:weather/data/model/internal/unit.dart';
import 'package:weather/data/repo/local/app_local_repo.dart';
import 'package:weather/utils/log_utils.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppLocalRepo _localRepository;

  AppBloc(this._localRepository) : super(AppState(Unit.metric));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is LoadSettingsAppEvent) {
      yield await _loadSetting();
    }
  }

  Future<AppState> _loadSetting() async {
    return AppState(await _localRepository.getSavedUnit());
  }

  bool isMetricUnits() {
    return state.unit == Unit.metric;
  }

  @override
  void onTransition(Transition<AppEvent, AppState> transition) {
    super.onTransition(transition);
    // LogUtil.d("AppBloc~");
    // print(transition);
  }
}
