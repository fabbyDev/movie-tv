import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/session_controller.dart';
import '../../../routes/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final sessionController = context.read<SessionController>();
    final user = sessionController.state!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(user.username),
              TextButton(
                onPressed: () async {
                  await sessionController.signOut();
                  if (mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.signIn,
                    );
                  }
                },
                child: const Text('sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
