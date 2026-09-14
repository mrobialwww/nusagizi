import 'package:nusagizi/features/mother/nutrition/domain/entities/cooking_step_entity.dart';

class CookingStepModel extends CookingStepEntity {
  const CookingStepModel({
    required super.id,
    super.recipeId,
    required super.stepNumber,
    required super.instruction,
    required super.imageUrl,
  });

  factory CookingStepModel.fromJson(Map<String, dynamic> json) {
    return CookingStepModel(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String?,
      stepNumber: (json['step_number'] as num?)?.toInt() ?? 1,
      instruction: json['instruction'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      'step_number': stepNumber,
      'instruction': instruction,
      'image_url': imageUrl,
    };
  }
}
