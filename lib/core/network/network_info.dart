import 'package:connectivity_plus/connectivity_plus.dart';

/// Lets repositories short-circuit before hitting the wire.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return results.any((ConnectivityResult r) => r != ConnectivityResult.none);
  }
}
