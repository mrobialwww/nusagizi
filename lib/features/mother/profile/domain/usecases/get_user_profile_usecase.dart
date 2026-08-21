import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/user_profile_repository.dart';

class GetUserProfileUseCase implements UseCaseNoParams<UserProfileEntity> {
  final UserProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserProfileEntity>> call() async {
    return await repository.getUserProfile();
  }
}
