class ChildSummaryEntity {
  final String id;
  final String name;
  final String age;
  final String imagePath;
  final int streak;
  final String statusTag;

  // Tumbuh (Growth)
  final double weightKg;
  final double heightCm;
  final String growthStatus;

  // Kembang (Development)
  final int developmentScore;
  final int developmentMaxScore;
  final String developmentStatus;

  // Gizi (Nutrition)
  final double proteinCurrent;
  final double proteinTarget;
  final String nutritionStatus;

  // Fokus Hari Ini
  final List<String> dailyFocuses;

  ChildSummaryEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.imagePath,
    required this.streak,
    required this.statusTag,
    required this.weightKg,
    required this.heightCm,
    required this.growthStatus,
    required this.developmentScore,
    required this.developmentMaxScore,
    required this.developmentStatus,
    required this.proteinCurrent,
    required this.proteinTarget,
    required this.nutritionStatus,
    required this.dailyFocuses,
  });

  ChildSummaryEntity copyWith({
    String? id,
    String? name,
    String? age,
    String? imagePath,
    int? streak,
    String? statusTag,
    double? weightKg,
    double? heightCm,
    String? growthStatus,
    int? developmentScore,
    int? developmentMaxScore,
    String? developmentStatus,
    double? proteinCurrent,
    double? proteinTarget,
    String? nutritionStatus,
    List<String>? dailyFocuses,
  }) {
    return ChildSummaryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      imagePath: imagePath ?? this.imagePath,
      streak: streak ?? this.streak,
      statusTag: statusTag ?? this.statusTag,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      growthStatus: growthStatus ?? this.growthStatus,
      developmentScore: developmentScore ?? this.developmentScore,
      developmentMaxScore: developmentMaxScore ?? this.developmentMaxScore,
      developmentStatus: developmentStatus ?? this.developmentStatus,
      proteinCurrent: proteinCurrent ?? this.proteinCurrent,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      nutritionStatus: nutritionStatus ?? this.nutritionStatus,
      dailyFocuses: dailyFocuses ?? this.dailyFocuses,
    );
  }
}
