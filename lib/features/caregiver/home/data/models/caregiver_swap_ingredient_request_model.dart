import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_swap_ingredient_request_entity.dart';

class CaregiverSwapIngredientRequestModel
    extends CaregiverSwapIngredientRequestEntity {
  const CaregiverSwapIngredientRequestModel({
    required super.recipeId,
    required super.slot,
    required super.priority,
  });

  factory CaregiverSwapIngredientRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CaregiverSwapIngredientRequestModel(
      recipeId: json['recipe_id'] as String? ?? '',
      slot: json['slot'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'recipe_id': recipeId, 'slot': slot, 'priority': priority};
  }
}
