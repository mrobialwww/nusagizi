import 'package:equatable/equatable.dart';

class CaregiverEngagementEntity extends Equatable {
  final String caregiverEngagementId;
  final String childId;
  final String childName;
  final String caregiverProfileId;
  final String caregiverName;
  final String? phoneNumber;

  const CaregiverEngagementEntity({
    required this.caregiverEngagementId,
    required this.childId,
    required this.childName,
    required this.caregiverProfileId,
    required this.caregiverName,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        caregiverEngagementId,
        childId,
        childName,
        caregiverProfileId,
        caregiverName,
        phoneNumber,
      ];
}
