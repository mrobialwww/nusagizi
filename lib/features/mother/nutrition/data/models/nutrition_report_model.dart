import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_report_entity.dart';

class NutritionReportModel extends NutritionReportEntity {
  const NutritionReportModel({
    required super.id,
    required super.createdAt,
    required super.calories,
    required super.status,
    required super.protein,
    required super.fat,
    required super.carbohydrate,
    required super.mealTimes,
  });

  factory NutritionReportModel.fromJson(Map<String, dynamic> json) {
    return NutritionReportModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Normal',
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      carbohydrate: (json['carbohydrate'] as num?)?.toDouble() ?? 0.0,
      mealTimes:
          (json['meal_times'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrate': carbohydrate,
      'meal_times': mealTimes,
    };
  }
}
