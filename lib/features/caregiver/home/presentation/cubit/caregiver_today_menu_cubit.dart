import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_today_menu_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_state.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';

class CaregiverTodayMenuCubit extends Cubit<CaregiverTodayMenuState> {
  final GetCaregiverTodayMenuUseCase getCaregiverTodayMenuUseCase;

  CaregiverTodayMenuCubit({required this.getCaregiverTodayMenuUseCase})
    : super(CaregiverTodayMenuInitial());

  Future<void> fetchTodayMenu(String childId) async {
    emit(CaregiverTodayMenuLoading());

    final result = await getCaregiverTodayMenuUseCase(childId);
    result.fold(
      (failure) => emit(CaregiverTodayMenuError(message: failure.message)),
      (data) => emit(CaregiverTodayMenuLoaded(data: data)),
    );
  }

  void markRecipeCompleted(String recipeId, double portionsConsumed) {
    if (state is CaregiverTodayMenuLoaded) {
      final loadedState = state as CaregiverTodayMenuLoaded;
      final currentMenu = loadedState.data.menu;
      if (currentMenu == null) return;

      // Optimistic UI update: modify state immediately
      final updatedRecipes = currentMenu.recipes.map((r) {
        if (r.id == recipeId) {
          return RecipeEntity(
            id: r.id,
            name: r.name,
            mealTime: r.mealTime,
            mealTexture: r.mealTexture,
            calories: r.calories,
            protein: r.protein,
            portionsConsumed: portionsConsumed,
          );
        }
        return r;
      }).toList();

      // Copy current menu and update completion state
      final updatedMenu = DailyMenuEntity(
        id: currentMenu.id,
        createdAt: currentMenu.createdAt,
        recipes: updatedRecipes,
      );

      final updatedData = CaregiverTodayMenuEntity(
        menu: updatedMenu,
        shoppingList: loadedState.data.shoppingList,
      );

      // Emit new state with updated completion state
      emit(CaregiverTodayMenuLoaded(data: updatedData));
    }
  }
}
