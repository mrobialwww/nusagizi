import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/caregiver_engagement_service.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/caregiver_engagement_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/caregiver_engagement_repository.dart';

class CaregiverEngagementRepositoryImpl
    implements CaregiverEngagementRepository {
  final CaregiverEngagementService service;

  CaregiverEngagementRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<CaregiverEngagementEntity>>>
  getActiveEngagements() async {
    try {
      final models = await service.getActiveEngagements();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CaregiverEngagementEntity>>>
  getRevokedEngagements() async {
    try {
      final models = await service.getRevokedEngagements();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeEngagement(String engagementId) async {
    try {
      await service.revokeEngagement(engagementId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
