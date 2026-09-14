import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/caregiver_engagement_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/caregiver_engagement_repository.dart';

class GetRevokedCaregiverEngagementsUseCase implements UseCaseNoParams<List<CaregiverEngagementEntity>> {
  final CaregiverEngagementRepository repository;

  GetRevokedCaregiverEngagementsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CaregiverEngagementEntity>>> call() async {
    return await repository.getRevokedEngagements();
  }
}
