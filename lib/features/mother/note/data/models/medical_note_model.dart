import 'package:nusagizi/core/utils/date_formatter.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';

class MedicalNoteModel extends MedicalNoteEntity {
  const MedicalNoteModel({
    required super.id,
    required super.validUntil,
    required super.recommendation,
    required super.createdAt,
    required super.childName,
    required super.prohibitionCount,
    required super.allergyCount,
  });

  factory MedicalNoteModel.fromJson(Map<String, dynamic> json) {
    return MedicalNoteModel(
      id: json['id'] ?? '',
      validUntil: AppDateFormatter.parseDate(json['valid_until']),
      recommendation: json['recommendation'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      childName: json['child_name'] ?? '',
      prohibitionCount: json['prohibition_count'] ?? 0,
      allergyCount: json['allergy_count'] ?? 0,
    );
  }
}
