import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';

abstract class NutritionTodayState extends Equatable {
  const NutritionTodayState();

  @override
  List<Object?> get props => [];
}

class NutritionTodayInitial extends NutritionTodayState {}

class NutritionTodayLoading extends NutritionTodayState {}

class NutritionTodayLoaded extends NutritionTodayState {
  final NutritionTodayEntity data;

  const NutritionTodayLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class NutritionTodayError extends NutritionTodayState {
  final String message;

  const NutritionTodayError({required this.message});

  @override
  List<Object?> get props => [message];
}
