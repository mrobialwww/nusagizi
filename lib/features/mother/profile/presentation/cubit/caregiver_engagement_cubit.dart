import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_active_caregiver_engagements_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_revoked_caregiver_engagements_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/revoke_caregiver_engagement_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_state.dart';

class CaregiverEngagementCubit extends Cubit<CaregiverEngagementState> {
  final GetActiveCaregiverEngagementsUseCase getActiveEngagementsUseCase;
  final GetRevokedCaregiverEngagementsUseCase getRevokedEngagementsUseCase;
  final RevokeCaregiverEngagementUseCase revokeCaregiverEngagementUseCase;

  CaregiverEngagementCubit({
    required this.getActiveEngagementsUseCase,
    required this.getRevokedEngagementsUseCase,
    required this.revokeCaregiverEngagementUseCase,
  }) : super(CaregiverEngagementInitial());

  Future<void> loadActiveEngagements() async {
    emit(CaregiverEngagementLoading());
    final result = await getActiveEngagementsUseCase();
    result.fold(
      (failure) => emit(CaregiverEngagementError(failure.message)),
      (engagements) => emit(CaregiverEngagementLoaded(engagements)),
    );
  }

  Future<void> loadRevokedEngagements() async {
    emit(CaregiverEngagementLoading());
    final result = await getRevokedEngagementsUseCase();
    result.fold(
      (failure) => emit(CaregiverEngagementError(failure.message)),
      (engagements) => emit(CaregiverEngagementLoaded(engagements)),
    );
  }

  Future<void> revokeEngagement(String engagementId) async {
    emit(CaregiverEngagementDeleteLoading());
    final result = await revokeCaregiverEngagementUseCase(engagementId);
    result.fold(
      (failure) => emit(CaregiverEngagementDeleteError(failure.message)),
      (_) {
        emit(CaregiverEngagementDeleteSuccess());
        // Reload list automatically
        loadActiveEngagements();
      },
    );
  }
}
