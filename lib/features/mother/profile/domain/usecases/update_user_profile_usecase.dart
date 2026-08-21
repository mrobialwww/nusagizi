import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/data/models/update_user_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase implements UseCase<void, UpdateUserProfileRequestModel> {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileRequestModel params) async {
    return await repository.updateUserProfile(params);
  }
}
