import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';

sealed class ChecklistMilestoneState extends Equatable {
  const ChecklistMilestoneState();

  @override
  List<Object?> get props => [];
}

class ChecklistMilestoneInitial extends ChecklistMilestoneState {
  const ChecklistMilestoneInitial();
}

class ChecklistMilestoneLoading extends ChecklistMilestoneState {
  const ChecklistMilestoneLoading();
}

class ChecklistMilestoneLoaded extends ChecklistMilestoneState {
  final List<ChecklistMilestoneTaskEntity> tasks;

  const ChecklistMilestoneLoaded({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

class ChecklistMilestoneError extends ChecklistMilestoneState {
  final String message;

  const ChecklistMilestoneError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChecklistMilestoneSyncSuccess extends ChecklistMilestoneState {
  final List<ChecklistMilestoneTaskEntity> tasks;

  const ChecklistMilestoneSyncSuccess({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}
