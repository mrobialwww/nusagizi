import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/caregiver_engagement_entity.dart';

abstract class CaregiverEngagementState extends Equatable {
  const CaregiverEngagementState();

  @override
  List<Object> get props => [];
}

class CaregiverEngagementInitial extends CaregiverEngagementState {}

class CaregiverEngagementLoading extends CaregiverEngagementState {}

class CaregiverEngagementLoaded extends CaregiverEngagementState {
  final List<CaregiverEngagementEntity> engagements;

  const CaregiverEngagementLoaded(this.engagements);

  @override
  List<Object> get props => [engagements];
}

class CaregiverEngagementError extends CaregiverEngagementState {
  final String message;

  const CaregiverEngagementError(this.message);

  @override
  List<Object> get props => [message];
}

class CaregiverEngagementDeleteLoading extends CaregiverEngagementState {}

class CaregiverEngagementDeleteSuccess extends CaregiverEngagementState {}

class CaregiverEngagementDeleteError extends CaregiverEngagementState {
  final String message;

  const CaregiverEngagementDeleteError(this.message);

  @override
  List<Object> get props => [message];
}
