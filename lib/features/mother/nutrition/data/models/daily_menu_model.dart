import 'package:nusagizi/features/mother/nutrition/data/models/recipe_model.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';

class DailyMenuModel extends DailyMenuEntity {
  const DailyMenuModel({
    required super.id,
    required super.createdAt,
    required super.recipes,
  });

  factory DailyMenuModel.fromJson(Map<String, dynamic> json) {
    return DailyMenuModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      recipes:
          (json['recipes'] as List<dynamic>?)
              ?.map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'recipes': recipes.map((r) => (r as RecipeModel).toJson()).toList(),
    };
  }
}
