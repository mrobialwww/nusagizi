import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/update_recipe_completion_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_state.dart';

class RecipeCompletionCubit extends Cubit<RecipeCompletionState> {
  final UpdateRecipeCompletionUseCase updateRecipeCompletionUseCase;

  RecipeCompletionCubit({required this.updateRecipeCompletionUseCase})
    : super(RecipeCompletionInitial());

  Future<void> updateCompletion(
    String recipeId,
    double portionsConsumed,
  ) async {
    emit(RecipeCompletionLoading());
    final result = await updateRecipeCompletionUseCase(
      recipeId,
      portionsConsumed,
      DateTime.now(),
    );

    result.fold(
      (failure) => emit(RecipeCompletionError(message: failure.message)),
      (_) => emit(RecipeCompletionSuccess()),
    );
  }
}
