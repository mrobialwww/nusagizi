import 'package:hydrated_bloc/hydrated_bloc.dart';

class DailyFocusCubit extends HydratedCubit<Map<String, List<int>>> {
  DailyFocusCubit() : super({});

  void toggleFocus(String childId, int index) {
    final current = state[childId] ?? [];
    final updated = List<int>.from(current);
    if (updated.contains(index)) {
      updated.remove(index);
    } else {
      updated.add(index);
    }
    emit({...state, childId: updated});
  }

  bool isChecked(String childId, int index) {
    return state[childId]?.contains(index) ?? false;
  }

  @override
  Map<String, List<int>>? fromJson(Map<String, dynamic> json) {
    try {
      final map = <String, List<int>>{};
      json.forEach((key, value) {
        if (value is List) {
          map[key] = value.cast<int>();
        }
      });
      return map;
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(Map<String, List<int>> state) {
    return state;
  }
}
