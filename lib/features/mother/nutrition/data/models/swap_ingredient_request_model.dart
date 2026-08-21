import 'package:nusagizi/features/mother/nutrition/domain/entities/swap_ingredient_request_entity.dart';

class SwapIngredientRequestModel extends SwapIngredientRequestEntity {
  const SwapIngredientRequestModel({
    required super.recipeId,
    required super.slot,
    required super.priority,
  });

  factory SwapIngredientRequestModel.fromJson(Map<String, dynamic> json) {
    return SwapIngredientRequestModel(
      recipeId: json['recipe_id'] as String? ?? '',
      slot: json['slot'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'recipe_id': recipeId, 'slot': slot, 'priority': priority};
  }
}
