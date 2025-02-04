import '../../domain/models/user/user.dart';
import '../../domain/repositories/acount_repository.dart';
import '../services/local/session_service.dart';
import '../services/remote/acount_api.dart';

class AcountRepositoryImpl implements AcountRepository {
  final AcountApi _acountApi;
  final SessionService _sessionService;

  AcountRepositoryImpl(
    this._acountApi,
    this._sessionService,
  );

  @override
  Future<User?> getUserData() async {
    return _acountApi.getAcount(await _sessionService.sessionId ?? '');
  }
}
