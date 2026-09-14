import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/caregiver_engagement_entity.dart';

abstract class CaregiverEngagementRepository {
  Future<Either<Failure, List<CaregiverEngagementEntity>>> getActiveEngagements();
  Future<Either<Failure, List<CaregiverEngagementEntity>>> getRevokedEngagements();
  Future<Either<Failure, void>> revokeEngagement(String engagementId);
}
