import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<void> addUser(User user);
}
