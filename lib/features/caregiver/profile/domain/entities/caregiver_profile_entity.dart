import 'package:equatable/equatable.dart';

class CaregiverProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String? gender;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final bool hasMotherProfile;
  final bool hasCaregiverProfile;

  const CaregiverProfileEntity({
    required this.id,
    required this.fullName,
    this.gender,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.hasMotherProfile,
    required this.hasCaregiverProfile,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    gender,
    email,
    phoneNumber,
    photoUrl,
    hasMotherProfile,
    hasCaregiverProfile,
  ];
}
