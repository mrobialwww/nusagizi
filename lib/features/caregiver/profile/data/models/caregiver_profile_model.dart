import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';

class CaregiverProfileModel extends CaregiverProfileEntity {
  const CaregiverProfileModel({
    required super.id,
    required super.fullName,
    super.gender,
    required super.email,
    super.phoneNumber,
    super.photoUrl,
    required super.hasMotherProfile,
    required super.hasCaregiverProfile,
  });

  factory CaregiverProfileModel.fromJson(Map<String, dynamic> json) {
    return CaregiverProfileModel(
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
