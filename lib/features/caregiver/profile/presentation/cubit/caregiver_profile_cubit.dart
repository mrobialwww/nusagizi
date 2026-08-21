import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';
import 'package:nusagizi/features/caregiver/profile/domain/usecases/get_caregiver_profile_usecase.dart';
import 'package:nusagizi/features/caregiver/profile/domain/usecases/update_caregiver_profile_usecase.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_state.dart';

class CaregiverProfileCubit extends Cubit<CaregiverProfileState> {
  final GetCaregiverProfileUseCase getCaregiverProfileUseCase;
  final UpdateCaregiverProfileUseCase updateCaregiverProfileUseCase;

  CaregiverProfileCubit({
    required this.getCaregiverProfileUseCase,
    required this.updateCaregiverProfileUseCase,
  }) : super(CaregiverProfileInitial());

  Future<void> loadProfile() async {
    emit(CaregiverProfileLoading());
    final result = await getCaregiverProfileUseCase();
    result.fold(
      (failure) => emit(CaregiverProfileError(failure.message)),
      (profile) => emit(CaregiverProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(UpdateCaregiverProfileRequestModel request) async {
    emit(CaregiverProfileUpdateLoading());
    final result = await updateCaregiverProfileUseCase(request);
    result.fold(
      (failure) => emit(CaregiverProfileUpdateError(failure.message)),
      (_) => emit(CaregiverProfileUpdateSuccess()),
    );
  }
}
