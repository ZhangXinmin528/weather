import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/log_utils.dart';

///网络连接状态监听
class ConnectionProvider {
  ConnectivityResult? _connectStatus;
  Connectivity? _connectivity;

  StreamSubscription<ConnectivityResult>? _connectSubScription;
  StreamController<ConnectivityResult> statusController = StreamController();

  static late final ConnectionProvider _instance = ConnectionProvider
      ._internal();

  factory ConnectionProvider() {
    return _instance;
  }

  ConnectionProvider._internal() {
    _connectivity = Connectivity();
    _connectStatus = ConnectivityResult.none;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = await _connectivity?.checkConnectivity();
      _listenStatus();
    } on PlatformException catch (e) {
      LogUtil.e("Could't check connectivity status, error : ${e.toString()}");
      return;
    }
    if (result != null) {
      _connectStatus = result;
      statusController.add(result);
    }
  }

  void _listenStatus() {
    _connectSubScription =
        _connectivity?.onConnectivityChanged.listen((result) {
          if (result != null) {
            _connectStatus = result;
            statusController.add(result);
            LogUtil.e("connectivity status : ${result.name}");
          }
        });
  }

  bool isNetworkConnected() {
    if (_connectStatus != null) {
      return _connectStatus == ConnectivityResult.wifi ||
          _connectStatus == ConnectivityResult.mobile;
    }
    return false;
  }

  void dispose() {
    _connectSubScription?.cancel();
    statusController.close();
  }
}
