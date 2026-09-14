import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/user_profile_service.dart';
import 'package:nusagizi/features/mother/profile/data/models/update_user_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileService service;

  UserProfileRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      final result = await service.getUserProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(
    UpdateUserProfileRequestModel data,
  ) async {
    try {
      await service.updateUserProfile(data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
