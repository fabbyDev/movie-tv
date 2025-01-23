import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../routes/routes.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  Function? cancelSubscriptionConnectivity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void init() {
    final connectivityRepository = context.read<ConnectivityRepository>();
    cancelSubscriptionConnectivity = connectivityRepository
        .listenChangeConnectivity(listenChangeConnectivity);
  }

  void listenChangeConnectivity(bool isOffline) {
    if (!isOffline) {
      Navigator.pushReplacementNamed(context, Routes.splash);
      cancelSubscriptionConnectivity!.call();
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelSubscriptionConnectivity!.call();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('offline View'),
      ),
    );
  }
}
