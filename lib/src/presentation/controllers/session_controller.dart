import '../../domain/models/user/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../global/state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  final AuthenticationRepository authenticationRepository;

  SessionController({required this.authenticationRepository}) : super(null);

  void setUser(User user) {
    state = user;
  }

  Future<void> signOut() async {
    await authenticationRepository.signOut();
    onlyUpdate(null);
  }
}
