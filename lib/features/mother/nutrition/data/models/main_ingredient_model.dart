import 'package:nusagizi/features/mother/nutrition/domain/entities/main_ingredient_entity.dart';

class MainIngredientModel extends MainIngredientEntity {
  const MainIngredientModel({
    required super.id,
    super.recipeId,
    super.ingredientId,
    required super.name,
    required super.unit,
    required super.priority,
    required super.slot,
    super.imageUrl,
  });

  factory MainIngredientModel.fromJson(Map<String, dynamic> json) {
    return MainIngredientModel(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String?,
      ingredientId: json['ingredient']?['ingredient_id'] as String?,
      name: json['ingredient']?['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      slot: json['slot'] as String? ?? '',
      imageUrl: json['ingredient']?['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      'name': name,
      'unit': unit,
      'priority': priority,
      'slot': slot,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
