import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';

abstract class DailyMenuState extends Equatable {
  const DailyMenuState();

  @override
  List<Object?> get props => [];
}

class DailyMenuInitial extends DailyMenuState {}

class DailyMenuLoading extends DailyMenuState {}

class DailyMenuLoaded extends DailyMenuState {
  final DailyMenuEntity menu;

  const DailyMenuLoaded(this.menu);

  @override
  List<Object?> get props => [menu];
}

class DailyMenuError extends DailyMenuState {
  final String message;

  const DailyMenuError(this.message);

  @override
  List<Object?> get props => [message];
}
