import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final int age;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
  });

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      name: user.name,
      age: user.age,
      address: user.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "address": address,
    };
  }
}
