import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/caregiver_alarm_model.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_alarm_state.dart';
import 'package:nusagizi/core/constants/alarm_dummy_data.dart';

class CaregiverAlarmCubit extends HydratedCubit<CaregiverAlarmState> {
  CaregiverAlarmCubit() : super(const CaregiverAlarmInitial(alarms: []));

  /// Dipanggil saat state belum di-restore dari storage (fresh install / data cleared).
  void initializeIfEmpty() {
    if (state.alarms.isEmpty) {
      final alarms = List.generate(alarmDummyData.length, (index) {
        final data = alarmDummyData[index];
        final timeString = data['time'] as String;
        final hour = int.parse(timeString.substring(0, 2));
        final minute = int.parse(timeString.substring(3, 5));

        return CaregiverAlarmModel(
          id: index + 101, // Caregiver IDs start from 101 to avoid collison
          title: data['title'] as String,
          hour: hour,
          minute: minute,
          isActive: data['isOn'] as bool,
        );
      });
      emit(CaregiverAlarmLoaded(alarms: alarms));
    }
  }

  Future<void> toggleAlarm(int index) async {
    final currentAlarms = List<CaregiverAlarmModel>.from(state.alarms);
    final alarm = currentAlarms[index];
    final updatedAlarm = alarm.copyWith(isActive: !alarm.isActive);
    currentAlarms[index] = updatedAlarm;
    emit(CaregiverAlarmLoaded(alarms: currentAlarms));
  }

  @override
  CaregiverAlarmState? fromJson(Map<String, dynamic> json) {
    if (json['alarms'] == null) return null;
    final alarms = (json['alarms'] as List<dynamic>)
        .map((e) => CaregiverAlarmModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return CaregiverAlarmLoaded(alarms: alarms);
  }

  @override
  Map<String, dynamic>? toJson(CaregiverAlarmState state) {
    return {'alarms': state.alarms.map((e) => e.toJson()).toList()};
  }
}
