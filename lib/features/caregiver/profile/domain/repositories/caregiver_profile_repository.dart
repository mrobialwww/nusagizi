import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';

abstract class CaregiverProfileRepository {
  Future<Either<Failure, CaregiverProfileEntity>> getCaregiverProfile();
  Future<Either<Failure, void>> updateCaregiverProfile(
    UpdateCaregiverProfileRequestModel data,
  );
}
