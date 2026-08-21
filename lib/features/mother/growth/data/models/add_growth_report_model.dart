class AddGrowthReportModel {
  final String childId;
  final DateTime measuredAt;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumferenceCm;

  AddGrowthReportModel({
    required this.childId,
    required this.measuredAt,
    this.weightKg,
    this.heightCm,
    this.headCircumferenceCm,
  });

  Map<String, dynamic> toJson() {
    final dateStr =
        '${measuredAt.day.toString().padLeft(2, '0')}-${measuredAt.month.toString().padLeft(2, '0')}-${measuredAt.year}';

    final data = <String, dynamic>{'measured_at': dateStr};

    if (heightCm != null) data['height_cm'] = heightCm;
    if (weightKg != null) data['weight_kg'] = weightKg;
    if (headCircumferenceCm != null) {
      data['head_circumference_cm'] = headCircumferenceCm;
    }

    return data;
  }
}
