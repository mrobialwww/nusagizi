import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';

abstract class CaregiverQRState extends Equatable {
  const CaregiverQRState();

  @override
  List<Object?> get props => [];
}

class CaregiverQRInitial extends CaregiverQRState {}

class CaregiverQRLoading extends CaregiverQRState {}

class CaregiverQRPreviewSuccess extends CaregiverQRState {
  final ChildPreviewEntity data;
  final String token;

  const CaregiverQRPreviewSuccess({required this.data, required this.token});

  @override
  List<Object?> get props => [data, token];
}

class CaregiverQRCheckinSuccess extends CaregiverQRState {
  final bool isNewEngagement;

  const CaregiverQRCheckinSuccess({required this.isNewEngagement});

  @override
  List<Object?> get props => [isNewEngagement];
}

class CaregiverQRError extends CaregiverQRState {
  final String message;
  final bool isCheckinError;

  const CaregiverQRError({required this.message, this.isCheckinError = false});

  @override
  List<Object?> get props => [message, isCheckinError];
}
