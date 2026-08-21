import 'package:equatable/equatable.dart';

class MedicalNoteRequestModel extends Equatable {
  final String? childId; // Required for Add, not passed for Edit
  final String? doctorName;
  final String? facilityName;
  final String? recommendation;
  final List<Map<String, dynamic>>? dailyNutritionTargets;
  final List<String>? prohibitions;
  final List<String>? allergies;
  final String? validUntil;

  const MedicalNoteRequestModel({
    this.childId,
    this.doctorName,
    this.facilityName,
    this.recommendation,
    this.dailyNutritionTargets,
    this.prohibitions,
    this.allergies,
    this.validUntil,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (childId != null) data['child_id'] = childId;
    if (doctorName != null) data['doctor_name'] = doctorName;
    if (facilityName != null) data['facility_name'] = facilityName;
    if (recommendation != null) data['recommendation'] = recommendation;
    if (dailyNutritionTargets != null) {
      data['daily_nutrition_targets'] = dailyNutritionTargets;
    }
    if (prohibitions != null) data['prohibitions'] = prohibitions;
    if (allergies != null) data['allergies'] = allergies;
    if (validUntil != null) data['valid_until'] = validUntil;
    return data;
  }

  @override
  List<Object?> get props => [
    childId,
    doctorName,
    facilityName,
    recommendation,
    dailyNutritionTargets,
    prohibitions,
    allergies,
    validUntil,
  ];
}
