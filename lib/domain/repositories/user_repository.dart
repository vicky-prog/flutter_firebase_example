import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> addUser(UserEntity user);
}
