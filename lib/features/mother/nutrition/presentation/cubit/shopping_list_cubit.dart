import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_daily_shop_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/swap_ingredient_request_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/swap_ingredient_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/substitute_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/shopping_list_state.dart';

class ShoppingListCubit extends HydratedCubit<ShoppingListState> {
  final GetDailyShopUseCase getDailyShopUseCase;
  final SwapIngredientUseCase swapIngredientUseCase;

  ShoppingListCubit({
    required this.getDailyShopUseCase,
    required this.swapIngredientUseCase,
  }) : super(ShoppingListInitial());

  Future<void> fetchDailyShop() async {
    // Get current checkedMap from state (if any)
    final currentCheckedMap = state is ShoppingListLoaded
        ? (state as ShoppingListLoaded).checkedMap
        : const <String, bool>{};

    emit(ShoppingListLoading());
    final result = await getDailyShopUseCase(DateTime.now());
    result.fold(
      (failure) => emit(ShoppingListError(failure.message)),
      (items) =>
          emit(ShoppingListLoaded(items: items, checkedMap: currentCheckedMap)),
    );
  }

  // Toggle item check status locally
  void toggleItemCheck(String itemName) {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final newMap = Map<String, bool>.from(currentState.checkedMap);
      newMap[itemName] = !(newMap[itemName] ?? false);
      emit(currentState.copyWith(checkedMap: newMap));
    }
  }

  // Reset all checked items — call this when a new menu is generated
  void clearCheckedItems() {
    if (state is ShoppingListLoaded) {
      emit((state as ShoppingListLoaded).copyWith(checkedMap: const {}));
    }
  }

  Future<void> swapIngredient(
    List<ShoppingItemEntity> items,
    String selectedSubstituteName,
  ) async {
    if (items.isEmpty) return;

    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final firstItem = items.first;
      final swapKey = '${firstItem.name}_${firstItem.childName}';

      // Optimistic UI update: show loading state immediately
      final loadingMap = Map<String, bool>.from(currentState.swapLoadingMap)
        ..[swapKey] = true;
      emit(currentState.copyWith(swapLoadingMap: loadingMap));

      // Batch collect swap requests for all related recipes
      final requests = <SwapIngredientRequestEntity>[];
      for (final item in items) {
        SubstituteItemEntity? matched;
        for (final sub in item.substitutes) {
          if (sub.name.trim().toLowerCase() ==
              selectedSubstituteName.trim().toLowerCase()) {
            matched = sub;
            break;
          }
        }

        // Find the specific priority for this substitute within this particular recipe
        if (matched != null) {
          requests.add(
            SwapIngredientRequestEntity(
              recipeId: item.recipeId,
              slot: item.slot,
              priority: matched.priority,
            ),
          );
        }
      }

      // Abort if the selected substitute is not found in any of the recipes
      if (requests.isEmpty) {
        final revertedMap = Map<String, bool>.from(
          (state as ShoppingListLoaded).swapLoadingMap,
        )..[swapKey] = false;
        emit(currentState.copyWith(swapLoadingMap: revertedMap));
        return;
      }

      final result = await swapIngredientUseCase(requests);

      result.fold((failure) {
        // Copy current map and revert swap loading state
        final revertedMap = Map<String, bool>.from(
          (state as ShoppingListLoaded).swapLoadingMap,
        )..[swapKey] = false;

        // Emit new state with updated swap loading map
        emit(
          (state as ShoppingListLoaded).copyWith(swapLoadingMap: revertedMap),
        );
      }, (_) async => await fetchDailyShop());
    }
  }

  @override
  ShoppingListState? fromJson(Map<String, dynamic> json) {
    try {
      final checkedMapData = json['checkedMap'] as Map<String, dynamic>?;
      if (checkedMapData != null) {
        final checkedMap = checkedMapData.map(
          (key, value) => MapEntry(key, value as bool),
        );
        return ShoppingListLoaded(items: const [], checkedMap: checkedMap);
      }
    } catch (_) {}
    return null;
  }

  @override
  Map<String, dynamic>? toJson(ShoppingListState state) {
    if (state is ShoppingListLoaded) return {'checkedMap': state.checkedMap};
    return null;
  }
}
