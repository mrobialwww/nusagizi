import 'package:nusagizi/features/mother/nutrition/data/models/daily_menu_model.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/nutrition_today_shopping_item_model.dart';

class NutritionTodayModel extends NutritionTodayEntity {
  const NutritionTodayModel({
    required super.id,
    required super.calories,
    required super.targetCalories,
    required super.protein,
    required super.targetProtein,
    required super.fat,
    required super.targetFat,
    required super.carbohydrate,
    required super.targetCarbohydrate,
    required super.status,
    super.menu,
    required super.shoppingList,
  });

  factory NutritionTodayModel.fromJson(Map<String, dynamic> json) {
    final menuJson = json['menu'] as Map<String, dynamic>?;

    return NutritionTodayModel(
      id: json['id'] as String,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      targetCalories: (json['target_calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      targetProtein: (json['target_protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      targetFat: (json['target_fat'] as num?)?.toDouble() ?? 0.0,
      carbohydrate: (json['carbohydrate'] as num?)?.toDouble() ?? 0.0,
      targetCarbohydrate:
          (json['target_carbohydrate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      menu: menuJson != null ? DailyMenuModel.fromJson(menuJson) : null,
      shoppingList:
          (json['shopping_list'] as List<dynamic>?)
              ?.map(
                (e) => NutritionTodayShoppingItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}
