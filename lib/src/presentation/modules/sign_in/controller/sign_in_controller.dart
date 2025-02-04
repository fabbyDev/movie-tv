import '../../../../domain/either.dart';
import '../../../../domain/enums.dart';
import '../../../../domain/models/user/user.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(super.state, {required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  Future<Either<SignInFailure, User>> submit() async {
    onFetchingChanged(true);
    final resultAuthentication = await authenticationRepository.signIn(
      state.username,
      state.password,
    );
    onFetchingChanged(false);

    return resultAuthentication;
  }

  void onUsernameChanged(String value) {
    state = state.copyWith(username: value.trim());
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value.trim());
  }

  void onFetchingChanged(bool value) {
    state = state.copyWith(fetching: value);
  }
}
