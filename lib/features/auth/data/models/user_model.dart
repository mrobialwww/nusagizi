// AUTH FEATURE - DATA LAYER
// Model: extends Entity, berisi logic serialisasi/deserialisasi JSON
import 'package:nuzagizi/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(id: entity.id, name: entity.name, email: entity.email);
  }
}
