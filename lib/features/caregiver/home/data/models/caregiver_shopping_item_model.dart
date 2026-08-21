import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/data/models/caregiver_substitute_item_model.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_substitute_item_entity.dart';

class CaregiverShoppingItemModel extends CaregiverShoppingItemEntity {
  const CaregiverShoppingItemModel({
    required super.name,
    required super.unit,
    required super.priority,
    required super.slot,
    required super.recipeId,
    required super.childName,
    required super.substitutes,
    super.isChecked = false,
  });

  factory CaregiverShoppingItemModel.fromJson(Map<String, dynamic> json) {
    final substitutesJson = json['substitutes'] as List<dynamic>? ?? [];
    final substitutes = substitutesJson
        .map<CaregiverSubstituteItemEntity>(
          (p) =>
              CaregiverSubstituteItemModel.fromJson(p as Map<String, dynamic>),
        )
        .toList();

    return CaregiverShoppingItemModel(
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
