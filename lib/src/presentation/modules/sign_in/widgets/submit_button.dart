import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enums.dart';
import '../../../controllers/session_controller.dart';
import '../../../routes/routes.dart';
import '../controller/sign_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  bool _validateForm(BuildContext context) {
    final signInController = context.read<SignInController>();
    return signInController.state.username.trim() != '' &&
        signInController.state.password.trim() != '';
  }

  void _submit(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final signInController = context.read<SignInController>();
    final result = await signInController.submit();

    result.when(
      (failure) {
        final messageFailure = {
          SignInFailure.notFound: 'Not Found',
          SignInFailure.unauthorized: 'Invalid Password',
          SignInFailure.network: 'Network Error',
          SignInFailure.unknow: 'Error',
        }[failure];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(messageFailure!),
          ),
        );
      },
      (user) {
        final sessionController = context.read<SessionController>();
        sessionController.setUser(user);
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final signInController = Provider.of<SignInController>(context);

    return signInController.state.fetching
        ? const CircularProgressIndicator()
        : FilledButton(
            onPressed: _validateForm(context) ? () => _submit(context) : null,
            style: const ButtonStyle(),
            child: const Text('Log in'),
          );
  }
}
