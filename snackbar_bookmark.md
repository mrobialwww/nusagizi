# Snackbar for Bookmark Toggle — Correct Plan

## Problem
User gets zero feedback when toggling bookmark. Snackbar must show **only after backend confirms** success/failure — not on optimistic update.

## Current Flow
1. `toggleBookmark()` → optimistic emit `RecipeDetailLoaded` (icon flips)
2. 800ms debounce → API call
3. Success: emit `RecipeDetailLoaded` with confirmed status
4. Failure: emit `RecipeDetailLoaded` with reverted status

**Issue**: Both success and failure emit `RecipeDetailLoaded` — no way to distinguish in UI.

## Solution
Add two dedicated states: `BookmarkSuccess` and `BookmarkError`. After API confirms, emit **only one** of these states (not `RecipeDetailLoaded`). Both carry `RecipeDetailEntity` so `BlocBuilder` can still render the UI.

## Changes

### 1. `recipe_detail_state.dart` — Add new states

```dart
class BookmarkSuccess extends RecipeDetailState {
  final RecipeDetailEntity recipeDetail;
  const BookmarkSuccess({required this.recipeDetail});

  @override
  List<Object?> get props => [recipeDetail];
}

class BookmarkError extends RecipeDetailState {
  final RecipeDetailEntity recipeDetail;
  final String message;
  const BookmarkError({required this.recipeDetail, required this.message});

  @override
  List<Object?> get props => [recipeDetail, message];
}
```

### 2. `recipe_detail_cubit.dart` — Emit new states after API confirms

In `toggleBookmark()`, change the debounce callback:

```dart
result.fold(
  (failure) {
    if (!isClosed && _bookmarkRevertTarget != null) {
      // Emit BookmarkError with reverted recipe data
      emit(BookmarkError(
        recipeDetail: _bookmarkRevertTarget!,
        message: 'Gagal mengubah bookmark',
      ));
    }
  },
  (isBookmarkedConfirmed) {
    if (!isClosed && state is RecipeDetailLoaded) {
      final currentState = state as RecipeDetailLoaded;
      // Emit BookmarkSuccess with confirmed recipe data
      emit(BookmarkSuccess(
        recipeDetail: currentState.recipeDetail.copyWith(
          isBookmarked: isBookmarkedConfirmed,
        ),
      ));
    }
  },
);
```

**Only 1 emit per API result.** No double emit.

### 3. `recipe_detail_page.dart` — Handle new states in builder + listener

Change `BlocBuilder` to `BlocConsumer`:

```dart
body: BlocConsumer<RecipeDetailCubit, RecipeDetailState>(
  bloc: _cubit,
  // LISTENER: show snackbar on success/error
  listener: (context, state) {
    if (state is BookmarkSuccess) {
      final msg = state.recipeDetail.isBookmarked
          ? 'Berhasil menyimpan resep'
          : 'Berhasil menghapus dari simpanan';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: Duration(seconds: 1)),
      );
    } else if (state is BookmarkError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
  // BUILDER: render UI for all 3 states
  builder: (context, state) {
    if (state is RecipeDetailLoading) { ... }
    else if (state is RecipeDetailError) { ... }
    else if (state is RecipeDetailLoaded ||
             state is BookmarkSuccess ||
             state is BookmarkError) {
      final data = state is RecipeDetailLoaded
          ? state.recipeDetail
          : state is BookmarkSuccess
              ? state.recipeDetail
              : (state as BookmarkError).recipeDetail;
      return SingleChildScrollView( ... );
    }
  },
),
```

## Summary

| Layer | What happens |
|-------|-------------|
| Cubit optimistic update | Emit `RecipeDetailLoaded` → icon flips immediately |
| Cubit API success | Emit `BookmarkSuccess` (1 emit) |
| Cubit API failure | Emit `BookmarkError` (1 emit) |
| Page builder | Handles 3 states → renders recipe UI |
| Page listener | Shows snackbar on `BookmarkSuccess` / `BookmarkError` |

## Behavior

| Scenario | Icon | Snackbar |
|----------|------|----------|
| User tap bookmark | Flips immediately (optimistic) | None |
| Backend success (~800ms) | Stays confirmed | Green: "Berhasil menyimpan/hapus" |
| Backend failure (~800ms) | Reverts back | Red: "Gagal mengubah bookmark" |
| Initial page load | Shows correct state | None |
