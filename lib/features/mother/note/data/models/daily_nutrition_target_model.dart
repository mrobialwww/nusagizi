import 'package:nusagizi/features/mother/note/domain/entities/daily_nutrition_target_entity.dart';

class DailyNutritionTargetModel extends DailyNutritionTargetEntity {
  const DailyNutritionTargetModel({
    required super.id,
    required super.nutrient,
    required super.quantity,
  });

  factory DailyNutritionTargetModel.fromJson(Map<String, dynamic> json) {
    return DailyNutritionTargetModel(
      id: json['id'] ?? '',
      nutrient: json['nutrient'] ?? '',
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}
