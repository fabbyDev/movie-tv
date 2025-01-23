import '../models/user.dart';

abstract class AcountRepository {
  Future<User?> getUserData();
}
