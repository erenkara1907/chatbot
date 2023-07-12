import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectionStatus { Online, Offline }

class ConnectivityService with ChangeNotifier {
  ConnectionStatus _connectionStatus = ConnectionStatus.Offline;

  ConnectionStatus get connectionStatus => _connectionStatus;

  ConnectivityService() {
    startMonitoring();
  }

  Future<void> startMonitoring() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        _connectionStatus = ConnectionStatus.Online;
        break;
      case ConnectivityResult.mobile:
        _connectionStatus = ConnectionStatus.Online;
        break;
      case ConnectivityResult.none:
        _connectionStatus = ConnectionStatus.Offline;
        break;
    }
    notifyListeners();
  }
}
