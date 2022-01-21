import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/log_utils.dart';

class ConnectProvider {
  ConnectivityResult? _connectStatus;
  Connectivity? _connectivity;

  static late final ConnectProvider _instance = ConnectProvider._internal();

  factory ConnectProvider() {
    return _instance;
  }

  ConnectProvider._internal() {
    _connectivity = Connectivity();
    _connectStatus = ConnectivityResult.none;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = await _connectivity?.checkConnectivity();
    } on PlatformException catch (e) {
      LogUtil.e("Could't check connectivity status, error : ${e.toString()}");
      return;
    }
  }
}
