import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_bookmarked_recipes_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/update_bookmark_recipe_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_state.dart';

class SavedRecipeCubit extends Cubit<SavedRecipeState> {
  final GetBookmarkedRecipesUseCase getBookmarkedRecipesUseCase;
  final UpdateBookmarkRecipeUseCase updateBookmarkRecipeUseCase;

  SavedRecipeCubit({
    required this.getBookmarkedRecipesUseCase,
    required this.updateBookmarkRecipeUseCase,
  }) : super(SavedRecipeInitial());

  Future<void> fetchSavedRecipes(String childId) async {
    emit(SavedRecipeLoading());
    final result = await getBookmarkedRecipesUseCase(childId);

    result.fold(
      (failure) => emit(SavedRecipeError(message: failure.message)),
      (recipes) => emit(SavedRecipeLoaded(recipes: recipes)),
    );
  }

  Future<void> removeBookmark(String recipeId) async {
    if (state is SavedRecipeLoaded) {
      final currentState = state as SavedRecipeLoaded;
      final currentRecipes = currentState.recipes;

      // Optimistically remove
      final updatedRecipes = currentRecipes
          .where((r) => r.id != recipeId)
          .toList();
      emit(SavedRecipeLoaded(recipes: updatedRecipes));

      final result = await updateBookmarkRecipeUseCase(recipeId, false);
      result.fold((failure) {
        // Revert on failure
        emit(SavedRecipeLoaded(recipes: currentRecipes));
      }, (_) {});
    }
  }
}
