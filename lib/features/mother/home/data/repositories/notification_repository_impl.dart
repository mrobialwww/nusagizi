import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/home/data/datasources/notification_service.dart';
import 'package:nusagizi/features/mother/home/domain/entities/notification_entity.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService service;

  NotificationRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<NotificationEntity>>>
  getAllNotifications() async {
    try {
      final notifications = await service.getAllNotifications();
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
