import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetChildDevelopmentSummary
    implements UseCase<ChildDevelopmentSummaryEntity, String> {
  final ChildDevelopmentRepository repository;

  GetChildDevelopmentSummary(this.repository);

  @override
  Future<Either<Failure, ChildDevelopmentSummaryEntity>> call(
    String childId,
  ) async {
    return await repository.getChildDevelopmentSummary(childId: childId);
  }
}
