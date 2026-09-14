import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/note/domain/entities/daily_nutrition_target_entity.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_restriction_entity.dart';

class MedicalNoteDetailEntity extends Equatable {
  final String id;
  final String doctorName;
  final String? facilityName;
  final String recommendation;
  final DateTime validDate;
  final DateTime createdAt;
  final String childName;
  final List<DailyNutritionTargetEntity> dailyNutritionTargets;
  final List<MedicalRestrictionEntity> medicalRestrictions;

  const MedicalNoteDetailEntity({
    required this.id,
    required this.doctorName,
    this.facilityName,
    required this.recommendation,
    required this.validDate,
    required this.createdAt,
    required this.childName,
    required this.dailyNutritionTargets,
    required this.medicalRestrictions,
  });

  @override
  List<Object?> get props => [
        id,
        doctorName,
        facilityName,
        recommendation,
        validDate,
        createdAt,
        childName,
        dailyNutritionTargets,
        medicalRestrictions,
      ];
}
