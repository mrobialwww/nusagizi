import 'package:nusagizi/core/utils/date_formatter.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/data/models/daily_nutrition_target_model.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_restriction_model.dart';

class MedicalNoteDetailModel extends MedicalNoteDetailEntity {
  const MedicalNoteDetailModel({
    required super.id,
    required super.doctorName,
    super.facilityName,
    required super.recommendation,
    required super.validDate,
    required super.createdAt,
    required super.childName,
    required super.dailyNutritionTargets,
    required super.medicalRestrictions,
  });

  factory MedicalNoteDetailModel.fromJson(Map<String, dynamic> json) {
    return MedicalNoteDetailModel(
      id: json['id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      facilityName: json['facility_name'],
      recommendation: json['recommendation'] ?? '',
      validDate: AppDateFormatter.parseDate(json['valid_until']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      childName: json['child_name'] ?? '',
      dailyNutritionTargets: (json['daily_nutrition_targets'] as List? ?? [])
          .map((i) => DailyNutritionTargetModel.fromJson(i))
          .toList(),
      medicalRestrictions: [
        ...(json['prohibitions'] as List? ?? []).map((i) => MedicalRestrictionModel(
            id: '', type: 'prohibition', restrictionName: i.toString())),
        ...(json['allergies'] as List? ?? []).map((i) => MedicalRestrictionModel(
            id: '', type: 'allergy', restrictionName: i.toString())),
      ],
    );
  }

}
