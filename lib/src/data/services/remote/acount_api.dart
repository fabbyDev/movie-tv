import '../../../domain/models/user.dart';
import '../../http/http.dart';

class AcountApi {
  AcountApi(this._http);

  final Http _http;

  Future<User?> getAcount(String sessionId) async {
    final response = await _http.get(
      "/account",
      queryParam: {"session_id": sessionId},
      onSuccess: (responseBody) => User.fromJson(responseBody),
    );

    return response.when(
      (_) => null,
      (user) => user,
    );
  }
}
