import 'package:nusagizi/features/mother/nutrition/data/models/cooking_step_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/main_ingredient_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/recipe_spice_model.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';

class RecipeDetailModel extends RecipeDetailEntity {
  const RecipeDetailModel({
    required super.id,
    required super.name,
    required super.mealTime,
    required super.mealTexture,
    required super.calories,
    required super.protein,
    required super.carbohydrate,
    required super.fat,
    required super.description,
    required super.cookingTime,
    required super.isBookmarked,
    required super.portionsConsumed,
    super.imageUrl,
    required super.mainIngredients,
    required super.recipeSpices,
    required super.cookingSteps,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      mealTime: json['meal_time'] as String? ?? '',
      mealTexture: json['meal_texture'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbohydrate: (json['carbohydrate'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      cookingTime: json['cooking_time'] as String? ?? '',
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
      portionsConsumed: (json['portions_consumed'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      mainIngredients:
          (json['main_ingredients'] as List<dynamic>?)
              ?.map(
                (e) => MainIngredientModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      recipeSpices:
          (json['recipe_spices'] as List<dynamic>?)
              ?.map((e) => RecipeSpiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cookingSteps:
          (json['cooking_steps'] as List<dynamic>?)
              ?.map((e) => CookingStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'meal_time': mealTime,
      'meal_texture': mealTexture,
      'calories': calories,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'description': description,
      'cooking_time': cookingTime,
      'is_bookmarked': isBookmarked,
      'portions_consumed': portionsConsumed,
      if (imageUrl != null) 'image_url': imageUrl,
      'main_ingredients': mainIngredients
          .map((e) => (e as MainIngredientModel).toJson())
          .toList(),
      'recipe_spices': recipeSpices
          .map((e) => (e as RecipeSpiceModel).toJson())
          .toList(),
      'cooking_steps': cookingSteps
          .map((e) => (e as CookingStepModel).toJson())
          .toList(),
    };
  }
}
