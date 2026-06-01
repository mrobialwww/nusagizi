import 'package:flutter/material.dart';
import 'package:nusagizi/core/domain/entities/child_development_summary.dart';

final List<ChildDevelopmentSummary> dummyChildDevelopmentSummaries = [
  // Data untuk Muhammad Razky
  const ChildDevelopmentSummary(
    badgeStatus: 'Sangat Baik',
    badgeColor: Color(0xFF3CB648),
    badgeBgColor: Color(0xFFDDEFDD),
    lastCheck: '05 Mei 2026',
    kpspScore: '9/10',
    nextCheck: '5 Juni 2026',
    motorikHalus: 4.0,
    motorikKasar: 3.5,
    sosialisasi: 4.0,
    bicara: 3.0,
    motorikHalusStatus: 'Cukup',
    motorikKasarStatus: 'Baik',
    sosialisasiStatus: 'Baik',
    bicaraStatus: 'Baik',
  ),
  // Data untuk Yuli
  const ChildDevelopmentSummary(
    badgeStatus: 'Perlu Perhatian',
    badgeColor: Color(0xFFFF9800),
    badgeBgColor: Color(0xFFFFEBD6),
    lastCheck: '10 April 2026',
    kpspScore: '6/10',
    nextCheck: '10 Mei 2026',
    motorikHalus: 2.5,
    motorikKasar: 3.0,
    sosialisasi: 2.0,
    bicara: 2.5,
    motorikHalusStatus: 'Kurang',
    motorikKasarStatus: 'Cukup',
    sosialisasiStatus: 'Kurang',
    bicaraStatus: 'Kurang',
  ),
];
