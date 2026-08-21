import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';

class NutritionTodayShoppingItem extends Equatable {
  final String name;
  final String ingredientId;
  final String unit;

  const NutritionTodayShoppingItem({
    required this.name,
    required this.ingredientId,
    required this.unit,
  });

  @override
  List<Object?> get props => [name, ingredientId, unit];
}

class NutritionTodayEntity extends Equatable {
  final String id;
  final double calories;
  final double targetCalories;
  final double protein;
  final double targetProtein;
  final double fat;
  final double targetFat;
  final double carbohydrate;
  final double targetCarbohydrate;
  final String status;
  final DailyMenuEntity? menu;
  final List<NutritionTodayShoppingItem> shoppingList;

  const NutritionTodayEntity({
    required this.id,
    required this.calories,
    required this.targetCalories,
    required this.protein,
    required this.targetProtein,
    required this.fat,
    required this.targetFat,
    required this.carbohydrate,
    required this.targetCarbohydrate,
    required this.status,
    this.menu,
    required this.shoppingList,
  });

  @override
  List<Object?> get props => [
    id,
    calories,
    targetCalories,
    protein,
    targetProtein,
    fat,
    targetFat,
    carbohydrate,
    targetCarbohydrate,
    status,
    menu,
    shoppingList,
  ];
}
