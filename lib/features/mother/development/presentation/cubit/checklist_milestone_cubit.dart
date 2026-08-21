import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/utils/age_parser.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_checklist_milestone_tasks.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/sync_checklist_milestone_progress.dart';

import 'checklist_milestone_state.dart';
export 'checklist_milestone_state.dart';

class ChecklistMilestoneCubit extends Cubit<ChecklistMilestoneState> {
  final GetChecklistMilestoneTasks getChecklistMilestoneTasks;
  final SyncChecklistMilestoneProgress syncChecklistMilestoneProgress;

  ChecklistMilestoneCubit({
    required this.getChecklistMilestoneTasks,
    required this.syncChecklistMilestoneProgress,
  }) : super(ChecklistMilestoneInitial());

  Timer? _syncDebounceTimer;
  String _childId = '';

  static const List<int> _kpspPeriods = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    30,
    36,
    42,
    48,
    54,
    60,
  ];

  int _snapToPeriod(int months) {
    return _kpspPeriods.lastWhere(
      (p) => p <= months,
      orElse: () => _kpspPeriods.first,
    );
  }

  int getSelectedMonth(String childAge) {
    final totalMonths = parseAgeToMonths(childAge);
    return _snapToPeriod(totalMonths);
  }

  Future<void> loadTasks({
    required String childId,
    required String childAge,
  }) async {
    _childId = childId;
    emit(ChecklistMilestoneLoading());
    final monthTarget = getSelectedMonth(childAge);
    final result = await getChecklistMilestoneTasks((
      monthTarget: monthTarget,
      childId: childId,
    ));
    result.fold(
      (failure) => emit(ChecklistMilestoneError(message: failure.message)),
      (tasks) {
        emit(ChecklistMilestoneLoaded(tasks: tasks));
      },
    );
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
    _syncDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _syncToServer();
    });
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
    // If timer is active (user exited quickly before debounce finished),
    // we fire the request immediately so we don't lose the last checkbox action.
    if (_syncDebounceTimer != null && _syncDebounceTimer!.isActive) {
      _syncDebounceTimer!.cancel();
      if (state is ChecklistMilestoneLoaded &&
          (state as ChecklistMilestoneLoaded).tasks.isNotEmpty) {
        _syncToServer();
      }
    }
    return super.close();
  }
}
