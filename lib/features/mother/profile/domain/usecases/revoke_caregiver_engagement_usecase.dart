import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/caregiver_engagement_repository.dart';

class RevokeCaregiverEngagementUseCase implements UseCase<void, String> {
  final CaregiverEngagementRepository repository;

  RevokeCaregiverEngagementUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.revokeEngagement(params);
  }
}
