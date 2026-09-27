import 'package:equatable/equatable.dart';

class NutritionReportEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final double calories;
  final String status;
  final double protein;
  final double fat;
  final double carbohydrate;
  final List<String> mealTimes;

  const NutritionReportEntity({
    required this.id,
    required this.createdAt,
    required this.calories,
    required this.status,
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
    status,
    protein,
    fat,
    carbohydrate,
    mealTimes,
  ];
}
