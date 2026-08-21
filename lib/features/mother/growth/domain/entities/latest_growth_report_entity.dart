import 'package:equatable/equatable.dart';

class LatestGrowthReportEntity extends Equatable {
  final String id;
  final DateTime measuredAt;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumferenceCm;
  final String status;
  final String description;

  const LatestGrowthReportEntity({
    required this.id,
    required this.measuredAt,
    this.weightKg,
    this.heightCm,
    this.headCircumferenceCm,
    required this.status,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        measuredAt,
        weightKg,
        heightCm,
        headCircumferenceCm,
        status,
        description,
      ];
}
