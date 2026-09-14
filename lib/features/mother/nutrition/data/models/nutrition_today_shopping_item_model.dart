import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';

class NutritionTodayShoppingItemModel extends NutritionTodayShoppingItem {
  const NutritionTodayShoppingItemModel({
    required super.name,
    required super.ingredientId,
    required super.unit,
  });

  factory NutritionTodayShoppingItemModel.fromJson(Map<String, dynamic> json) {
    return NutritionTodayShoppingItemModel(
      name: json['name'] as String? ?? '',
      ingredientId: json['ingredient_id'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'ingredient_id': ingredientId, 'unit': unit};
  }
}
