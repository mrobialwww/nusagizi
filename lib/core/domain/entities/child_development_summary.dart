import 'package:flutter/material.dart';

class ChildDevelopmentSummary {
  final String badgeStatus;
  final Color badgeColor;
  final Color badgeBgColor;
  final String lastCheck;
  final String kpspScore;
  final String nextCheck;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;
  final String motorikHalusStatus;
  final String motorikKasarStatus;
  final String sosialisasiStatus;
  final String bicaraStatus;

  const ChildDevelopmentSummary({
    required this.badgeStatus,
    required this.badgeColor,
    required this.badgeBgColor,
    required this.lastCheck,
    required this.kpspScore,
    required this.nextCheck,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
    required this.motorikHalusStatus,
    required this.motorikKasarStatus,
    required this.sosialisasiStatus,
    required this.bicaraStatus,
  });
}
