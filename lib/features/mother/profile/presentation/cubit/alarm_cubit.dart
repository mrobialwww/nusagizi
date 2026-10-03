import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/mother/profile/data/models/alarm_model.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/alarm_state.dart';
import 'package:nusagizi/core/constants/alarm_dummy_data.dart';

class AlarmCubit extends HydratedCubit<AlarmState> {
  AlarmCubit() : super(const AlarmInitial(alarms: []));

  /// Dipanggil saat state belum di-restore dari storage (fresh install / data cleared).
  void initializeIfEmpty() {
    if (state.alarms.isEmpty) {
      final alarms = List.generate(alarmDummyData.length, (index) {
        final data = alarmDummyData[index];
        final timeString = data['time'] as String;
        final hour = int.parse(timeString.substring(0, 2));
        final minute = int.parse(timeString.substring(3, 5));

        return AlarmModel(
          id: index + 1,
          title: data['title'] as String,
          hour: hour,
          minute: minute,
          isActive: data['isOn'] as bool,
        );
      });
      emit(AlarmLoaded(alarms: alarms));
    }
  }

  Future<void> toggleAlarm(int index) async {
    final currentAlarms = List<AlarmModel>.from(state.alarms);
    final alarm = currentAlarms[index];
    final updatedAlarm = alarm.copyWith(isActive: !alarm.isActive);
    currentAlarms[index] = updatedAlarm;
    emit(AlarmLoaded(alarms: currentAlarms));
  }

  @override
  AlarmState? fromJson(Map<String, dynamic> json) {
    if (json['alarms'] == null) return null;
    final alarms = (json['alarms'] as List<dynamic>)
        .map((e) => AlarmModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return AlarmLoaded(alarms: alarms);
  }

  @override
  Map<String, dynamic>? toJson(AlarmState state) {
    return {'alarms': state.alarms.map((e) => e.toJson()).toList()};
  }
}
