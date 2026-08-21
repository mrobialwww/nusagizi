import 'package:nusagizi/features/mother/nutrition/domain/entities/substitute_item_entity.dart';

class SubstituteItemModel extends SubstituteItemEntity {
  const SubstituteItemModel({
    required super.name,
    required super.unit,
    required super.priority,
    required super.slot,
  });

  factory SubstituteItemModel.fromJson(Map<String, dynamic> json) {
    return SubstituteItemModel(
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 2,
      slot: json['slot'] as String? ?? '',
    );
  }
}
