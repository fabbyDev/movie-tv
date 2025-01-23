import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/acount_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../../presentation/routes/routes.dart';
import '../../../controllers/session_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  void _init() async {
    final connectivityRepository = context.read<ConnectivityRepository>();
    final authenticationRepository = context.read<AuthenticationRepository>();
    final accountRepository = context.read<AcountRepository>();
    final sessionController = context.read<SessionController>();

    // if has not internet conection, show the offline page
    if (!await connectivityRepository.hasInternet) {
      goTo(Routes.offline);
      return;
    }

    // if has not session, show the sign in page
    if (!await authenticationRepository.isSignedIn) {
      goTo(Routes.signIn);
      return;
    }

    final user = await accountRepository.getUserData();

    if (user != null) {
      sessionController.setUser(user);
      goTo(Routes.home);
    }
    goTo(Routes.signIn);
  }

  void goTo(String routeName) {
    if (mounted) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
