import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';

class ChildProfileModel extends ChildProfileEntity {
  const ChildProfileModel({
    required super.id,
    required super.fullName,
    required super.age,
    required super.gender,
    super.photoUrl,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    return ChildProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      photoUrl: json['photo_url'],
    );
  }
}
