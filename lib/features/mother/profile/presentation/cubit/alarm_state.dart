import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/profile/data/models/alarm_model.dart';

abstract class AlarmState extends Equatable {
  final List<AlarmModel> alarms;

  const AlarmState({required this.alarms});

  @override
  List<Object?> get props => [alarms];
}

class AlarmInitial extends AlarmState {
  const AlarmInitial({required super.alarms});
}

class AlarmLoaded extends AlarmState {
  const AlarmLoaded({required super.alarms});
}
