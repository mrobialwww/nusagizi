import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/models/update_user_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UpdateUserProfileRequestModel data);
}
