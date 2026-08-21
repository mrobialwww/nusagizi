import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    super.gender,
    required super.email,
    super.phoneNumber,
    super.photoUrl,
    required super.hasMotherProfile,
    required super.hasCaregiverProfile,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      gender: json['gender'],
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      photoUrl: json['photo_url'],
      hasMotherProfile: json['has_mother_profile'] ?? false,
      hasCaregiverProfile: json['has_caregiver_profile'] ?? false,
    );
  }
}
