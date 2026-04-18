import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(_hasConnectionFromResult);
  }

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnectionFromResult(result);
  }

  bool _hasConnectionFromResult(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }
}
