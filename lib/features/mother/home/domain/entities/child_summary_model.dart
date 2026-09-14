class ChildSummaryModel {
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

  ChildSummaryModel({
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
}
