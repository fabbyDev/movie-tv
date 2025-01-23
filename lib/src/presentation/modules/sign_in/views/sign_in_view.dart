import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../controller/sign_in_controller.dart';
import '../controller/sign_in_state.dart';
import '../widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(
        const SignInState(
          username: '',
          password: '',
          fetching: false,
        ),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              child: Builder(builder: (context) {
                final signInController = Provider.of<SignInController>(context);
                return AbsorbPointer(
                  absorbing: signInController.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'username',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          value = value?.trim() ?? '';
                          return (value.isEmpty)
                              ? 'username is required'
                              : null;
                        },
                        textInputAction: TextInputAction.next,
                        onChanged: (value) =>
                            signInController.onUsernameChanged(
                          value.trim(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'password',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          value = value?.trim() ?? '';
                          return (value.isEmpty)
                              ? 'password is required'
                              : null;
                        },
                        onChanged: (value) =>
                            signInController.onPasswordChanged(
                          value.trim(),
                        ),
                        textInputAction: TextInputAction.send,
                        // onFieldSubmitted: (_) => ,
                      ),
                      const SizedBox(height: 25),
                      const SubmitButton()
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
