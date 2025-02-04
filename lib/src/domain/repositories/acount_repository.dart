import '../models/user/user.dart';

abstract class AcountRepository {
  Future<User?> getUserData();
}
