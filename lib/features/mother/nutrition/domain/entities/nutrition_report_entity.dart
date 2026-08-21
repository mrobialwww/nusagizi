import 'package:equatable/equatable.dart';

class NutritionReportEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final double calories;
  final double targetCalories;
  final double protein;
  final double fat;
  final double carbohydrate;
  final List<String> mealTimes;

  const NutritionReportEntity({
    required this.id,
    required this.createdAt,
    required this.calories,
    required this.targetCalories,
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.mealTimes,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    calories,
    targetCalories,
    protein,
    fat,
    carbohydrate,
    mealTimes,
  ];
}
