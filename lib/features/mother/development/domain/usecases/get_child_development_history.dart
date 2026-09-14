import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetChildDevelopmentHistory
    implements UseCase<List<ChildDevelopmentHistoryEntity>, String> {
  GetChildDevelopmentHistory(this.repository);

  final ChildDevelopmentRepository repository;

  @override
  Future<Either<Failure, List<ChildDevelopmentHistoryEntity>>> call(
    String childId,
  ) async {
    return repository.getDevelopmentHistory(childId: childId);
  }
}
