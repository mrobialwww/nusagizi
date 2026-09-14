import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';

abstract class CaregiverTodayMenuState extends Equatable {
  const CaregiverTodayMenuState();

  @override
  List<Object> get props => [];
}

class CaregiverTodayMenuInitial extends CaregiverTodayMenuState {}

class CaregiverTodayMenuLoading extends CaregiverTodayMenuState {}

class CaregiverTodayMenuLoaded extends CaregiverTodayMenuState {
  final CaregiverTodayMenuEntity data;

  const CaregiverTodayMenuLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class CaregiverTodayMenuError extends CaregiverTodayMenuState {
  final String message;

  const CaregiverTodayMenuError({required this.message});

  @override
  List<Object> get props => [message];
}
