import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';
import 'package:nusagizi/features/caregiver/profile/domain/repositories/caregiver_profile_repository.dart';

class UpdateCaregiverProfileUseCase
    implements UseCase<void, UpdateCaregiverProfileRequestModel> {
  final CaregiverProfileRepository repository;

  UpdateCaregiverProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
    UpdateCaregiverProfileRequestModel params,
  ) async {
    return await repository.updateCaregiverProfile(params);
  }
}
