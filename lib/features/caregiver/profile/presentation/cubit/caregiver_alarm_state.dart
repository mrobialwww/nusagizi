import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/caregiver_alarm_model.dart';

abstract class CaregiverAlarmState extends Equatable {
  final List<CaregiverAlarmModel> alarms;

  const CaregiverAlarmState({required this.alarms});

  @override
  List<Object?> get props => [alarms];
}

class CaregiverAlarmInitial extends CaregiverAlarmState {
  const CaregiverAlarmInitial({required super.alarms});
}

class CaregiverAlarmLoaded extends CaregiverAlarmState {
  const CaregiverAlarmLoaded({required super.alarms});
}
