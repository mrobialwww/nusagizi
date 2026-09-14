import 'package:nusagizi/features/mother/profile/domain/entities/caregiver_engagement_entity.dart';

class CaregiverEngagementModel extends CaregiverEngagementEntity {
  const CaregiverEngagementModel({
    required super.caregiverEngagementId,
    required super.childId,
    required super.childName,
    required super.caregiverProfileId,
    required super.caregiverName,
    super.phoneNumber,
  });

  factory CaregiverEngagementModel.fromJson(Map<String, dynamic> json) {
    return CaregiverEngagementModel(
      caregiverEngagementId: json['caregiver_engagement_id']?.toString() ?? '',
      childId: json['child_id']?.toString() ?? '',
      childName: json['child_name'] ?? '',
      caregiverProfileId: json['caregiver_profile_id']?.toString() ?? '',
      caregiverName: json['caregiver_name'] ?? '',
      phoneNumber: json['phone_number']?.toString(),
    );
  }
}
