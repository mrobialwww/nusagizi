import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/home/domain/entities/notification_entity.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/notification_repository.dart';

class GetAllNotificationsUseCase
    implements UseCaseNoParams<List<NotificationEntity>> {
  final NotificationRepository repository;

  GetAllNotificationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return repository.getAllNotifications();
  }
}
