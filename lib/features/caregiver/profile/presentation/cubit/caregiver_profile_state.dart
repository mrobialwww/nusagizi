import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';

abstract class CaregiverProfileState extends Equatable {
  const CaregiverProfileState();

  @override
  List<Object> get props => [];
}

class CaregiverProfileInitial extends CaregiverProfileState {}

class CaregiverProfileLoading extends CaregiverProfileState {}

class CaregiverProfileLoaded extends CaregiverProfileState {
  final CaregiverProfileEntity profile;

  const CaregiverProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class CaregiverProfileError extends CaregiverProfileState {
  final String message;

  const CaregiverProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class CaregiverProfileUpdateLoading extends CaregiverProfileState {}

class CaregiverProfileUpdateSuccess extends CaregiverProfileState {}

class CaregiverProfileUpdateError extends CaregiverProfileState {
  final String message;

  const CaregiverProfileUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
