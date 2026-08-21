import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_cubit.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Extra untuk navigasi ProfileMotherPage → EditProfilePage
// Membawa cubit (untuk updateProfile & refresh setelah save)
// dan data profile yang sudah di-load (untuk pre-fill form tanpa API call ulang)
// ─────────────────────────────────────────────────────────────────────────────
class EditProfileExtra {
  final UserProfileCubit cubit;
  final UserProfileEntity profile;

  const EditProfileExtra({required this.cubit, required this.profile});
}

// ─────────────────────────────────────────────────────────────────────────────
// Extra untuk navigasi ProfileCaregiverPage → CaregiverEditProfilePage
// ─────────────────────────────────────────────────────────────────────────────
class CaregiverEditProfileExtra {
  final CaregiverProfileCubit cubit;
  final CaregiverProfileEntity profile;

  const CaregiverEditProfileExtra({required this.cubit, required this.profile});
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter KPSP Result
// Digunakan saat navigasi dari KpspAssessmentPage → KpspResultPage
// ─────────────────────────────────────────────────────────────────────────────
class KpspResultExtra {
  final String childName;
  final String childAge;
  final String reportId;
  final bool isFromHistory;
  final String childId;
  final bool showRetakeButton;

  const KpspResultExtra({
    required this.childName,
    required this.childAge,
    required this.reportId,
    this.isFromHistory = false,
    required this.childId,
    this.showRetakeButton = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter KPSP Assessment
// Digunakan saat navigasi ke KpspAssessmentPage
// ─────────────────────────────────────────────────────────────────────────────
class KpspAssessmentExtra {
  final String childName;
  final String childAge;
  final String childId;
  final String? existingReportId;

  const KpspAssessmentExtra({
    required this.childName,
    required this.childAge,
    required this.childId,
    this.existingReportId,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter DevelopmentProfileDetailPage
// Digunakan saat navigasi ke DevelopmentProfileDetailPage
// ─────────────────────────────────────────────────────────────────────────────
class DevelopmentProfileDetailExtra {
  final String childName;
  final String childAge;
  final String childId;
  final String reportId;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;

  const DevelopmentProfileDetailExtra({
    required this.childName,
    required this.childAge,
    required this.childId,
    required this.reportId,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Model untuk extra parameter Checklist Milestone Page
// Digunakan saat navigasi dari DevelopmentPage → ChecklistMilestonePage
// ─────────────────────────────────────────────────────────────────────────────
class ChecklistMilestoneExtra {
  final String childId;
  final String childAge;

  const ChecklistMilestoneExtra({required this.childId, required this.childAge});
}
