import 'package:equatable/equatable.dart';

class ChildDevelopmentSummaryEntity extends Equatable {
  const ChildDevelopmentSummaryEntity({
    required this.id,
    required this.badgeStatus,
    required this.lastCheck,
    required this.kpspScore,
    required this.kpspTotal,
    required this.nextCheck,
    this.nextCheckDate,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
  });

  final String id;
  final String badgeStatus;
  final String lastCheck;
  final int kpspScore;
  final int kpspTotal;
  final String nextCheck;
  final DateTime? nextCheckDate;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;

  @override
  List<Object?> get props => [
    id,
    badgeStatus,
    lastCheck,
    kpspScore,
    kpspTotal,
    nextCheck,
    nextCheckDate,
    motorikHalus,
    motorikKasar,
    sosialisasi,
    bicara,
  ];
}
