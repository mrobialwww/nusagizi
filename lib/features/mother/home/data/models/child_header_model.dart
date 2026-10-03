import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';

class ChildHeaderModel extends ChildHeaderEntity {
  const ChildHeaderModel({
    required super.id,
    required super.name,
    required super.age,
    required super.imagePath,
    required super.gender,
  });

  factory ChildHeaderModel.fromChildProfileEntity(ChildProfileEntity entity) {
    return ChildHeaderModel(
      id: entity.id,
      name: entity.fullName,
      age: entity.age,
      imagePath: entity.photoUrl ?? '',
      gender: entity.gender,
    );
  }

  factory ChildHeaderModel.fromJson(Map<String, dynamic> json) {
    return ChildHeaderModel(
      id: json['id'] ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      age: json['age'] ?? '',
      imagePath:
          json['photo_url'] as String? ?? json['imagePath'] as String? ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'imagePath': imagePath,
      'gender': gender,
    };
  }
}
