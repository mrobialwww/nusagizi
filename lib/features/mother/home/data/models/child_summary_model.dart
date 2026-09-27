import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';

class ChildSummaryModel extends ChildSummaryEntity {
  ChildSummaryModel({
    required super.id,
    required super.name,
    required super.age,
    required super.imagePath,
    required super.gender,
    required super.streak,
    required super.statusTag,
    required super.weightKg,
    required super.heightCm,
    required super.growthStatus,
    required super.developmentScore,
    required super.developmentMaxScore,
    required super.developmentStatus,
    required super.proteinCurrent,
    required super.proteinTarget,
    required super.nutritionStatus,
    required super.dailyFocuses,
  });

  factory ChildSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChildSummaryModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? '',
      age: json['age'] ?? '',
      imagePath: json['photo_url'] ?? '',
      gender: json['gender'] ?? '',
      streak: json['streak'] ?? 0,
      statusTag: json['status'] ?? '',
      weightKg: (json['weight_kg'] ?? 0.0).toDouble(),
      heightCm: (json['height_cm'] ?? 0.0).toDouble(),
      growthStatus: json['status_growth'] ?? '',
      developmentScore: json['kpsp_score'] ?? 0,
      developmentMaxScore: json['kpsp_answers_count'] ?? 0,
      developmentStatus: json['status_development'] ?? '',
      proteinCurrent: (json['protein'] as num?)?.toDouble() ?? 0.0,
      proteinTarget: (json['target_protein'] as num?)?.toDouble() ?? 0.0,
      nutritionStatus: json['status_nutrition'] ?? '',
      dailyFocuses: const [], // Will be injected via usecase
    );
  }
}
