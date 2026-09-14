import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/substitute_item_model.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/substitute_item_entity.dart';

class ShoppingItemModel extends ShoppingItemEntity {
  const ShoppingItemModel({
    required super.name,
    required super.unit,
    required super.priority,
    required super.slot,
    required super.recipeId,
    required super.childName,
    required super.substitutes,
    super.isChecked = false,
  });

  factory ShoppingItemModel.fromJson(Map<String, dynamic> json) {
    final substitutesJson = json['substitutes'] as List<dynamic>? ?? [];
    final substitutes = substitutesJson
        .map<SubstituteItemEntity>(
          (p) => SubstituteItemModel.fromJson(p as Map<String, dynamic>),
        )
        .toList();

    return ShoppingItemModel(
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      slot: json['slot'] as String? ?? '',
      recipeId: json['recipe_id'] as String? ?? '',
      childName: json['child_name'] as String? ?? '',
      substitutes: substitutes,
    );
  }
}
