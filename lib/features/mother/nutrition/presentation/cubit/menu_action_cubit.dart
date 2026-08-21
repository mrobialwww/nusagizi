import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/generate_menu_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/reuse_recipe_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/shopping_list_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_shopping_list_cubit.dart';

class MenuActionCubit extends Cubit<MenuActionState> {
  final GenerateMenuUseCase generateMenuUseCase;
  final ReuseRecipeUseCase reuseRecipeUseCase;
  final ShoppingListCubit shoppingListCubit;
  final CaregiverShoppingListCubit caregiverShoppingListCubit;

  MenuActionCubit({
    required this.generateMenuUseCase,
    required this.reuseRecipeUseCase,
    required this.shoppingListCubit,
    required this.caregiverShoppingListCubit,
  }) : super(MenuActionInitial());

  Future<void> generateMenu() async {
    emit(MenuActionGenerateLoading());
    final result = await generateMenuUseCase(DateTime.now());
    result.fold(
      (failure) {
        emit(MenuActionError(failure.message));
      },
      (_) {
        shoppingListCubit.clearCheckedItems();
        caregiverShoppingListCubit.clearCheckedItems();
        emit(MenuActionGenerateSuccess());
      },
    );
  }

  Future<void> reuseRecipe({
    required String childId,
    required String sourceRecipeId,
  }) async {
    emit(MenuActionReuseLoading());
    final result = await reuseRecipeUseCase(
      childId,
      sourceRecipeId,
      DateTime.now(),
    );
    result.fold(
      (failure) {
        emit(MenuActionError(failure.message));
      },
      (_) {
        shoppingListCubit.clearCheckedItems();
        caregiverShoppingListCubit.clearCheckedItems();
        emit(MenuActionReuseSuccess());
      },
    );
  }

  void resetState() {
    emit(MenuActionInitial());
  }
}
