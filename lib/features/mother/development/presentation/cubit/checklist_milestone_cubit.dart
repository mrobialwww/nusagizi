import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_checklist_milestone_tasks.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/sync_checklist_milestone_progress.dart';
import 'checklist_milestone_state.dart';

class ChecklistMilestoneCubit extends Cubit<ChecklistMilestoneState> {
  final GetChecklistMilestoneTasks getChecklistMilestoneTasks;
  final SyncChecklistMilestoneProgress syncChecklistMilestoneProgress;

  ChecklistMilestoneCubit({
    required this.getChecklistMilestoneTasks,
    required this.syncChecklistMilestoneProgress,
  }) : super(const ChecklistMilestoneInitial());

  Timer? _syncDebounceTimer;
  String _childId = '';

  Future<void> loadTasks({
    required String childId,
    required int monthTarget,
  }) async {
    _childId = childId;
    emit(const ChecklistMilestoneLoading());

    final result = await getChecklistMilestoneTasks((
      monthTarget: monthTarget,
      childId: childId,
    ));
    result.fold(
      (failure) => emit(ChecklistMilestoneError(failure.message)),
      (tasks) => emit(ChecklistMilestoneLoaded(tasks: tasks)),
    );
  }

  Future<void> _syncToServer() async {
    if (state is! ChecklistMilestoneLoaded) return;

    final currentState = state as ChecklistMilestoneLoaded;
    final checkedIds = currentState.tasks
        .where((task) => task.isChecked)
        .map((task) => task.id)
        .toList();

    await syncChecklistMilestoneProgress((
      childId: _childId,
      assessmentKpspQuestionIds: checkedIds,
    ));
  }

  @override
  Future<void> close() {
    // Fire immediately if user exits before debounce completes.
    if (_syncDebounceTimer != null && _syncDebounceTimer!.isActive) {
      _syncDebounceTimer!.cancel();
      if (state is ChecklistMilestoneLoaded &&
          (state as ChecklistMilestoneLoaded).tasks.isNotEmpty) {
        _syncToServer();
      }
    }
    return super.close();
  }

  void toggleTask(String taskId) {
    if (state is! ChecklistMilestoneLoaded) return;

    final currentState = state as ChecklistMilestoneLoaded;
    final updatedTasks = currentState.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isChecked: !task.isChecked);
      }
      return task;
    }).toList();

    emit(ChecklistMilestoneLoaded(tasks: updatedTasks));

    // Reset debounce timer
    _syncDebounceTimer?.cancel();
    _syncDebounceTimer = Timer(
      const Duration(milliseconds: 500),
      _syncToServer,
    );
  }
}
