import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.mealTime,
    required super.mealTexture,
    required super.calories,
    required super.protein,
    required super.portionsConsumed,
    super.imageUrl,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mealTime: json['meal_time'] as String,
      mealTexture: json['meal_texture'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      portionsConsumed: (json['portions_consumed'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
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
      'portions_consumed': portionsConsumed,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
