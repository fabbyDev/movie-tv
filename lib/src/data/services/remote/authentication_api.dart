import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode) {
        case 401:
          return Either.left(SignInFailure.unauthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknow);
      }
    }

    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network);
    }

    return Either.left(SignInFailure.unknow);
  }

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.get<String>(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final data = responseBody as Map;
        return data['request_token'];
      },
    );

    return result.when(
      _handleFailure,
      (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final response = await _http.post<String>(
      '/authentication/token/validate_with_login',
      body: {
        "username": username,
        "password": password,
        "request_token": requestToken
      },
      onSuccess: (responseBody) {
        final data = responseBody as Map;
        return data['request_token'] as String;
      },
    );

    return response.when(
      _handleFailure,
      (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SignInFailure, String>> createSessionId(
    String requestToken,
  ) async {
    final response = await _http.post<String>(
      '/authentication/session/new',
      body: {
        "request_token": requestToken,
      },
      onSuccess: (responseBody) {
        final data = responseBody as Map;
        return data['session_id'] as String;
      },
    );

    return response.when(
      _handleFailure,
      (sessionId) => Either.right(sessionId),
    );
  }
}
