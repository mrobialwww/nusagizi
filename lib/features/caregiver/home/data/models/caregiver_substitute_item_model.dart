import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_substitute_item_entity.dart';

class CaregiverSubstituteItemModel extends CaregiverSubstituteItemEntity {
  const CaregiverSubstituteItemModel({
    required super.name,
    required super.unit,
    required super.priority,
    required super.slot,
  });

  factory CaregiverSubstituteItemModel.fromJson(Map<String, dynamic> json) {
    return CaregiverSubstituteItemModel(
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 2,
      slot: json['slot'] as String? ?? '',
    );
  }
}
