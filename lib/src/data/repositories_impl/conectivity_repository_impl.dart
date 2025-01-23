import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._connectivity);
  final Connectivity _connectivity;

  @override
  Future<bool> get hasInternet async {
    List<ConnectivityResult> connectivityResult =
        await (_connectivity.checkConnectivity());

    final bool connectivityAcepted =
        (connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.vpn) ||
            // for pc devices
            connectivityResult.contains(ConnectivityResult.ethernet));

    if (!connectivityAcepted) return false;
    if (kIsWeb) return connectivityAcepted;
    return testInternetConnection();
  }

  Future<bool> testInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('google.com');
      return (response.isNotEmpty && response.first.rawAddress.isNotEmpty);
    } catch (e) {
      return false;
    }
  }

  @override
  Function listenChangeConnectivity(Function(bool isOffline) listener) {
    final subscription = _connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        listener(connectivityResult.contains(ConnectivityResult.none));
      },
    );

    return () => subscription.cancel();
  }
}
