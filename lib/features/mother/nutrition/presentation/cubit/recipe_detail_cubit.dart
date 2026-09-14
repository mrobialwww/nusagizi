import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_recipe_detail_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/update_bookmark_recipe_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  final GetRecipeDetailUseCase getRecipeDetailUseCase;
  final UpdateBookmarkRecipeUseCase updateBookmarkRecipeUseCase;

  RecipeDetailCubit({
    required this.getRecipeDetailUseCase,
    required this.updateBookmarkRecipeUseCase,
  }) : super(RecipeDetailInitial());

  Timer? _bookmarkDebounceTimer;
  RecipeDetailEntity? _bookmarkRevertTarget;

  Future<void> fetchRecipeDetail(String recipeId) async {
    emit(RecipeDetailLoading());
    final result = await getRecipeDetailUseCase(recipeId);
    result.fold(
      (failure) => emit(RecipeDetailError(message: failure.message)),
      (detail) => emit(RecipeDetailLoaded(recipeDetail: detail)),
    );
  }

  void toggleBookmark() {
    if (state is! RecipeDetailLoaded) return;

    final currentRecipe = (state as RecipeDetailLoaded).recipeDetail;

    // Save original state for revert (only on first click in debounce session)
    _bookmarkRevertTarget ??= currentRecipe;

    final newStatus = !currentRecipe.isBookmarked;

    // Optimistic update
    emit(
      RecipeDetailLoaded(
        recipeDetail: currentRecipe.copyWith(isBookmarked: newStatus),
      ),
    );

    // Reset debounce timer
    _bookmarkDebounceTimer?.cancel();
    _bookmarkDebounceTimer = Timer(const Duration(milliseconds: 800), () async {
      final loadedState = state;
      if (loadedState is! RecipeDetailLoaded) return;

      final result = await updateBookmarkRecipeUseCase(
        loadedState.recipeDetail.id,
        loadedState.recipeDetail.isBookmarked,
      );

      result.fold(
        (failure) {
          if (!isClosed && _bookmarkRevertTarget != null) {
            emit(BookmarkError(
              recipeDetail: _bookmarkRevertTarget!,
              message: 'Gagal mengubah bookmark',
            ));
          }
        },
        (isBookmarkedConfirmed) {
          if (!isClosed && state is RecipeDetailLoaded) {
            final currentState = state as RecipeDetailLoaded;
            emit(BookmarkSuccess(
              recipeDetail: currentState.recipeDetail.copyWith(
                isBookmarked: isBookmarkedConfirmed,
              ),
            ));
          }
        },
      );

      _bookmarkRevertTarget = null;
    });
  }

  @override
  Future<void> close() {
    // If timer is active (user exited quickly before debounce finished), 
    // we fire the request immediately so we don't lose the bookmark action.
    if (_bookmarkDebounceTimer != null && _bookmarkDebounceTimer!.isActive) {
      _bookmarkDebounceTimer!.cancel();
      if (state is RecipeDetailLoaded) {
        final loadedState = state as RecipeDetailLoaded;
        // Fire and forget
        updateBookmarkRecipeUseCase(
          loadedState.recipeDetail.id,
          loadedState.recipeDetail.isBookmarked,
        );
      }
    }
    return super.close();
  }
}
