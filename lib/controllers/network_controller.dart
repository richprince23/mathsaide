import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late StreamSubscription<ConnectivityResult> connectivitySubscription;

class NetworkProvider extends ChangeNotifier {
  bool? _isConnected;
  bool get isConnected => _isConnected ?? false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();

  void setConnection(bool status) async {
    _isConnected = status;
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await connectivity.checkConnectivity();
    } on PlatformException {
      rethrow;
    }

    // Determine the primary connectivity result from the list
    ConnectivityResult result = _determineConnectivityResult(results);

    notifyListeners();
    return updateConnectionStatus(result);
  }

  /// Determine the primary connectivity result from the list
  /// Priority: wifi > mobile > ethernet > other > none
  ConnectivityResult _determineConnectivityResult(
    List<ConnectivityResult> results,
  ) {
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityResult.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityResult.mobile;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityResult.ethernet;
    } else if (results.contains(ConnectivityResult.other)) {
      return ConnectivityResult.other;
    } else {
      return ConnectivityResult.none;
    }
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    notifyListeners();
  }
}
