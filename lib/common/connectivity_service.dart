import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus {
  WiFi,
  Cellular,
  Offline,
}

class ConnectivityService with ChangeNotifier {
  ConnectivityStatus _status = ConnectivityStatus.Offline;
  final Connectivity _connectivity = Connectivity();

  ConnectivityStatus get status => _status;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    _initializeConnectionStatus();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _status = ConnectivityStatus.Offline;
    } else {
      // Determine the connectivity status based on the list of results
      if (results.contains(ConnectivityResult.wifi)) {
        _status = ConnectivityStatus.WiFi;
      } else if (results.contains(ConnectivityResult.mobile)) {
        _status = ConnectivityStatus.Cellular;
      } else {
        _status = ConnectivityStatus.Offline;
      }
    }
    notifyListeners();
  }

  Future<void> _initializeConnectionStatus() async {
    try {
      List<ConnectivityResult> initialResults = await _connectivity.checkConnectivity();
      _updateConnectionStatus(initialResults);
    } catch (e) {
      _updateConnectionStatus([]);
    }
  }
}
