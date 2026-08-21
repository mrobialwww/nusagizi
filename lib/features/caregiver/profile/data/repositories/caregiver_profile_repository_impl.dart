import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/profile/data/datasources/caregiver_profile_service.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';
import 'package:nusagizi/features/caregiver/profile/domain/repositories/caregiver_profile_repository.dart';

class CaregiverProfileRepositoryImpl implements CaregiverProfileRepository {
  final CaregiverProfileService service;

  CaregiverProfileRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, CaregiverProfileEntity>> getCaregiverProfile() async {
    try {
      final result = await service.getCaregiverProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCaregiverProfile(
    UpdateCaregiverProfileRequestModel data,
  ) async {
    try {
      await service.updateCaregiverProfile(data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
