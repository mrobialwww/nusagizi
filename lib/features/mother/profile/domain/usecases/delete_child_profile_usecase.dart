import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';

class DeleteChildProfileUseCase {
  final ChildProfileRepository repository;

  DeleteChildProfileUseCase({required this.repository});

  Future<Either<Failure, void>> call(String childId) async {
    return await repository.deleteChildProfile(childId);
  }
}
