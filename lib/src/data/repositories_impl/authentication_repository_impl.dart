import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/local/session_service.dart';
import '../services/remote/acount_api.dart';
import '../services/remote/authentication_api.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SessionService _sessionService;
  final AuthenticationAPI _authenticationAPI;
  final AcountApi _acountAPI;

  AuthenticationRepositoryImpl(
    this._sessionService,
    this._authenticationAPI,
    this._acountAPI,
  );

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _sessionService.sessionId;
    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    final requestTokenResponse = await _authenticationAPI.createRequestToken();

    return requestTokenResponse.when(
      (failure) => Either.left(failure),
      (requestToken) async {
        final loginResult = await _authenticationAPI.createSessionWithLogin(
          username: username,
          password: password,
          requestToken: requestToken,
        );

        //
        return loginResult.when(
          (signInFailure) => Either.left(signInFailure),
          (newRequestToken) async {
            final sessionResult =
                await _authenticationAPI.createSessionId(requestToken);
            return sessionResult.when(
              (signInFailure) => Either.left(signInFailure),
              (sessionId) async {
                _sessionService.save(sessionId);
                final user = await _acountAPI.getAcount(sessionId);
                return user != null
                    ? Either.right(user)
                    : Either.left(SignInFailure.notFound);
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _sessionService.delete();
  }
}
