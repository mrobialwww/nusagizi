import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';

class GetChildrenUseCase implements UseCaseNoParams<List<ChildProfileEntity>> {
  final ChildProfileRepository repository;

  GetChildrenUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChildProfileEntity>>> call() async {
    return await repository.getChildren();
  }
}
