import 'package:intl/intl.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';

class LatestGrowthReportModel extends LatestGrowthReportEntity {
  const LatestGrowthReportModel({
    required super.id,
    required super.measuredAt,
    super.weightKg,
    super.heightCm,
    super.headCircumferenceCm,
    required super.status,
    required super.description,
  });

  factory LatestGrowthReportModel.fromJson(Map<String, dynamic> json) {
    // API returns measured_at as DD-MM-YYYY (e.g. 04-05-2026)
    final measuredAtStr = json['measured_at'] as String;
    DateTime measuredAt;
    try {
      measuredAt = DateTime.parse(measuredAtStr);
    } catch (_) {
      measuredAt = DateFormat('dd-MM-yyyy').parse(measuredAtStr);
    }

    return LatestGrowthReportModel(
      id: json['id'] as String,
      measuredAt: measuredAt,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      headCircumferenceCm: (json['head_circumference_cm'] as num?)?.toDouble(),
      status: json['status'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'measured_at': DateFormat('dd-MM-yyyy').format(measuredAt),
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (headCircumferenceCm != null)
        'head_circumference_cm': headCircumferenceCm,
      'status': status,
      'description': description,
    };
  }
}
