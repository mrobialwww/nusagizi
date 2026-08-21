import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetChecklistMilestoneTasks
    implements UseCase<List<ChecklistMilestoneTaskEntity>, ({int monthTarget, String childId})> {
  final ChildDevelopmentRepository repository;

  GetChecklistMilestoneTasks(this.repository);

  @override
  Future<Either<Failure, List<ChecklistMilestoneTaskEntity>>> call(
    ({int monthTarget, String childId}) params,
  ) async {
    return await repository.getChecklistMilestoneTasks(
      monthTarget: params.monthTarget,
      childId: params.childId,
    );
  }
}
