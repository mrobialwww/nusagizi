import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/update_caregiver_recipe_completion_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_completion_state.dart';

class CaregiverRecipeCompletionCubit
    extends Cubit<CaregiverRecipeCompletionState> {
  final UpdateCaregiverRecipeCompletionUseCase
  updateCaregiverRecipeCompletionUseCase;

  CaregiverRecipeCompletionCubit({
    required this.updateCaregiverRecipeCompletionUseCase,
  }) : super(CaregiverRecipeCompletionInitial());

  Future<void> updateCompletion(
    String recipeId,
    double portionsConsumed,
  ) async {
    emit(CaregiverRecipeCompletionLoading());
    final result = await updateCaregiverRecipeCompletionUseCase(
      recipeId,
      portionsConsumed,
      DateTime.now(),
    );

    result.fold(
      (failure) =>
          emit(CaregiverRecipeCompletionError(message: failure.message)),
      (_) => emit(CaregiverRecipeCompletionSuccess()),
    );
  }
}
