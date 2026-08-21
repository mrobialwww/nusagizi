import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/home/domain/entities/notification_entity.dart';

abstract class CaregiverNotificationState extends Equatable {
  const CaregiverNotificationState();

  @override
  List<Object> get props => [];
}

class CaregiverNotificationInitial extends CaregiverNotificationState {}

class CaregiverNotificationLoading extends CaregiverNotificationState {}

class CaregiverNotificationLoaded extends CaregiverNotificationState {
  final List<NotificationEntity> notifications;

  const CaregiverNotificationLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class CaregiverNotificationError extends CaregiverNotificationState {
  final String message;

  const CaregiverNotificationError({required this.message});

  @override
  List<Object> get props => [message];
}
