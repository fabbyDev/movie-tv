abstract class ConnectivityRepository {
  Future<bool> get hasInternet;
  Function listenChangeConnectivity(Function(bool isOffline) listener);
}
