import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';
import 'package:nusagizi/features/caregiver/profile/domain/repositories/caregiver_profile_repository.dart';

class GetCaregiverProfileUseCase
    implements UseCaseNoParams<CaregiverProfileEntity> {
  final CaregiverProfileRepository repository;

  GetCaregiverProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, CaregiverProfileEntity>> call() async {
    return await repository.getCaregiverProfile();
  }
}
