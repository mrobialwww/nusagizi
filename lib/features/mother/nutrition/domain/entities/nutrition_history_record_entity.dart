import 'package:equatable/equatable.dart';

class NutritionHistoryRecordEntity extends Equatable {
  final String dateStr;
  final bool isTargetReached;
  final bool isSickCondition;
  final String intakeLabel;
  final String intakeSubLabel;
  final double totalKcal;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;
  final String? doctorNote;

  const NutritionHistoryRecordEntity({
    required this.dateStr,
    required this.isTargetReached,
    required this.isSickCondition,
    required this.intakeLabel,
    required this.intakeSubLabel,
    required this.totalKcal,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
    this.doctorNote,
  });

  @override
  List<Object?> get props => [
    dateStr,
    isTargetReached,
    isSickCondition,
    intakeLabel,
    intakeSubLabel,
    totalKcal,
    totalProtein,
    totalFat,
    totalCarbs,
    doctorNote,
  ];
}
