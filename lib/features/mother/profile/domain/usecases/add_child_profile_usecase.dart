import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';

class AddChildProfileUseCase implements UseCase<String, ChildProfileRequestModel> {
  final ChildProfileRepository repository;

  AddChildProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(ChildProfileRequestModel params) {
    return repository.addChildProfile(params);
  }
}
