import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/cooking_step_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/main_ingredient_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_spice_entity.dart';

class RecipeDetailEntity extends Equatable {
  final String id;
  final String name;
  final String mealTime;
  final String mealTexture;
  final double calories;
  final double protein;
  final double carbohydrate;
  final double fat;
  final String description;
  final String cookingTime;
  final bool isBookmarked;
  final double portionsConsumed;
  final String? imageUrl;
  final List<MainIngredientEntity> mainIngredients;
  final List<RecipeSpiceEntity> recipeSpices;
  final List<CookingStepEntity> cookingSteps;

  const RecipeDetailEntity({
    required this.id,
    required this.name,
    required this.mealTime,
    required this.mealTexture,
    required this.calories,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.description,
    required this.cookingTime,
    required this.isBookmarked,
    required this.portionsConsumed,
    this.imageUrl,
    required this.mainIngredients,
    required this.recipeSpices,
    required this.cookingSteps,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    mealTime,
    mealTexture,
    calories,
    protein,
    carbohydrate,
    fat,
    description,
    cookingTime,
    isBookmarked,
    portionsConsumed,
    imageUrl,
    mainIngredients,
    recipeSpices,
    cookingSteps,
  ];

  RecipeDetailEntity copyWith({
    String? id,
    String? name,
    String? mealTime,
    String? mealTexture,
    double? calories,
    double? protein,
    double? carbohydrate,
    double? fat,
    String? description,
    String? cookingTime,
    bool? isBookmarked,
    double? portionsConsumed,
    String? imageUrl,
    List<MainIngredientEntity>? mainIngredients,
    List<RecipeSpiceEntity>? recipeSpices,
    List<CookingStepEntity>? cookingSteps,
  }) {
    return RecipeDetailEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      mealTime: mealTime ?? this.mealTime,
      mealTexture: mealTexture ?? this.mealTexture,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      fat: fat ?? this.fat,
      description: description ?? this.description,
      cookingTime: cookingTime ?? this.cookingTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      portionsConsumed: portionsConsumed ?? this.portionsConsumed,
      imageUrl: imageUrl ?? this.imageUrl,
      mainIngredients: mainIngredients ?? this.mainIngredients,
      recipeSpices: recipeSpices ?? this.recipeSpices,
      cookingSteps: cookingSteps ?? this.cookingSteps,
    );
  }
}
