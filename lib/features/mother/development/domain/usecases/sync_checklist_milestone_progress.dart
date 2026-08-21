import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class SyncChecklistMilestoneProgress implements UseCase<void, ({String childId, List<String> assessmentKpspQuestionIds})> {
  final ChildDevelopmentRepository repository;

  SyncChecklistMilestoneProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(
    ({String childId, List<String> assessmentKpspQuestionIds}) params,
  ) async {
    return await repository.syncChecklistMilestoneProgress(
      childId: params.childId,
      assessmentKpspQuestionIds: params.assessmentKpspQuestionIds,
    );
  }
}
