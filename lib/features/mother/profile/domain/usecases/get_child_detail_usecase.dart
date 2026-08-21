import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';

class GetChildDetailUseCase implements UseCase<ChildEntity, String> {
  final ChildProfileRepository repository;
  GetChildDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, ChildEntity>> call(String childId) {
    return repository.getChildDetail(childId);
  }
}
