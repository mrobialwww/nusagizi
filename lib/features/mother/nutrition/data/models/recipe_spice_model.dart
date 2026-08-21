import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_spice_entity.dart';

class RecipeSpiceModel extends RecipeSpiceEntity {
  const RecipeSpiceModel({
    required super.id,
    super.recipeId,
    required super.name,
    required super.unit,
  });

  factory RecipeSpiceModel.fromJson(Map<String, dynamic> json) {
    return RecipeSpiceModel(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String?,
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      'name': name,
      'unit': unit,
    };
  }
}
