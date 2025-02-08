import 'package:flutter_firebase_example/data/model/user_model.dart';
import 'package:flutter_firebase_example/domain/entities/user_entity.dart';
import 'package:flutter_firebase_example/domain/repositories/user_repository.dart';

import '../datasources/firebase_user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<void> addUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _datasource.addUserData(
        userId: userModel.id,
        data: userModel.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

/*
class FirebaseUserRepository {
  final FirebaseUserDatasource _datasource;

  FirebaseUserRepository(this._datasource);

  Future<void> addUser(UserEntity user) async {
    final data = {
      "name": user.name,
      "age": user.age,
      "address": user.address,
    };
    await _datasource.setUserData(user.id, data);
  }

  Future<UserEntity?> getUser(String userId) async {
    final data = await _datasource.getUserData(userId);
    if (data != null) {
      return UserEntity(
        id: userId,
        name: data['name'],
        age: data['age'],
        address: data['address'],
      );
    }
    return null;
  }
}*/
