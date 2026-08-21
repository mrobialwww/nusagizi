import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';

class UpdateChildProfileUseCase {
  final ChildProfileRepository repository;

  UpdateChildProfileUseCase({required this.repository});

  Future<Either<Failure, void>> call(String childId, ChildProfileRequestModel request) async {
    return await repository.updateChildProfile(childId, request);
  }
}
