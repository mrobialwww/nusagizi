import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final String notificationType;
  final String createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, message, notificationType, createdAt];
}
