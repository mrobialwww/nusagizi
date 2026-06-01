import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter KPSP Result
// Digunakan saat navigasi dari KpspAssessmentPage → KpspResultPage
// ─────────────────────────────────────────────────────────────────────────────
class KpspResultExtra {
  final String childName;
  final String childAge;
  final List<KpspQuestion> questions;
  final List<bool> answers;

  const KpspResultExtra({
    required this.childName,
    required this.childAge,
    required this.questions,
    required this.answers,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter KPSP Assessment
// Digunakan saat navigasi ke KpspAssessmentPage
// ─────────────────────────────────────────────────────────────────────────────
class KpspAssessmentExtra {
  final String childName;
  final String childAge;

  const KpspAssessmentExtra({required this.childName, required this.childAge});
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter DevelopmentProfileDetailPage
// Digunakan saat navigasi ke DevelopmentProfileDetailPage
// ─────────────────────────────────────────────────────────────────────────────
class DevelopmentProfileDetailExtra {
  final String childName;
  final String childAge;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;
  final String motorikHalusStatus;
  final String motorikKasarStatus;
  final String sosialisasiStatus;
  final String bicaraStatus;

  const DevelopmentProfileDetailExtra({
    required this.childName,
    required this.childAge,
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
