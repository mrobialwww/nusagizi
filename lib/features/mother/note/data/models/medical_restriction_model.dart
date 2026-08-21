import 'package:nusagizi/features/mother/note/domain/entities/medical_restriction_entity.dart';

class MedicalRestrictionModel extends MedicalRestrictionEntity {
  const MedicalRestrictionModel({
    required super.id,
    required super.type,
    required super.restrictionName,
  });

  factory MedicalRestrictionModel.fromJson(Map<String, dynamic> json) {
    return MedicalRestrictionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      restrictionName: json['restriction_name'] ?? '',
    );
  }
}
