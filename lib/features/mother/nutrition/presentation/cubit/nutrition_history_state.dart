import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_report_entity.dart';

abstract class NutritionHistoryState extends Equatable {
  const NutritionHistoryState();

  @override
  List<Object?> get props => [];
}

class NutritionHistoryInitial extends NutritionHistoryState {}

class NutritionHistoryLoading extends NutritionHistoryState {}

class NutritionHistoryLoaded extends NutritionHistoryState {
  final List<NutritionReportEntity> reports;

  const NutritionHistoryLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class NutritionHistoryError extends NutritionHistoryState {
  final String message;

  const NutritionHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
