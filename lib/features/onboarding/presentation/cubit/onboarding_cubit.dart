import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/onboarding/domain/usecases/submit_role_usecase.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SubmitRoleUseCase submitRoleUseCase;

  OnboardingCubit({required this.submitRoleUseCase}) : super(OnboardingInitial());

  Future<void> submitRole(String role) async {
    emit(OnboardingLoading());

    final result = await submitRoleUseCase(role);

    result.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (_) => emit(OnboardingSuccess(role: role)),
    );
  }
}
