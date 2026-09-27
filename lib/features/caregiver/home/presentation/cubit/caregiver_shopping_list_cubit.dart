import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_daily_shop_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_swap_ingredient_request_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/swap_caregiver_ingredient_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_substitute_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_shopping_list_state.dart';

class CaregiverShoppingListCubit
    extends HydratedCubit<CaregiverShoppingListState> {
  final GetCaregiverDailyShopUseCase getDailyShopUseCase;
  final SwapCaregiverIngredientUseCase swapIngredientUseCase;

  CaregiverShoppingListCubit({
    required this.getDailyShopUseCase,
    required this.swapIngredientUseCase,
  }) : super(CaregiverShoppingListInitial());

  Future<void> fetchCaregiverDailyShop(String childId) async {
    final currentCheckedMap = state is CaregiverShoppingListLoaded
        ? (state as CaregiverShoppingListLoaded).checkedMap
        : const <String, bool>{};

    emit(CaregiverShoppingListLoading());
    final result = await getDailyShopUseCase(childId);
    result.fold(
      (failure) => emit(CaregiverShoppingListError(failure.message)),
      (items) => emit(
        CaregiverShoppingListLoaded(
          items: items,
          checkedMap: currentCheckedMap,
        ),
      ),
    );
  }

  void toggleItemCheck(String itemName) {
    if (state is CaregiverShoppingListLoaded) {
      final currentState = state as CaregiverShoppingListLoaded;

      final newMap = Map<String, bool>.from(currentState.checkedMap);
      newMap[itemName] = !(newMap[itemName] ?? false);

      emit(currentState.copyWith(checkedMap: newMap));
    }
  }

  void clearCheckedItems() {
    if (state is CaregiverShoppingListLoaded) {
      emit(
        (state as CaregiverShoppingListLoaded).copyWith(checkedMap: const {}),
      );
    }
  }

  Future<void> swapIngredient(
    List<CaregiverShoppingItemEntity> items,
    String selectedSubstituteName,
    String childId,
  ) async {
    if (items.isEmpty) return;

    if (state is CaregiverShoppingListLoaded) {
      final currentState = state as CaregiverShoppingListLoaded;
      final firstItem = items.first;
      final swapKey = '${firstItem.name}_${firstItem.childName}';

      final loadingMap = Map<String, bool>.from(currentState.swapLoadingMap)
        ..[swapKey] = true;
      emit(currentState.copyWith(swapLoadingMap: loadingMap));

      final requests = <CaregiverSwapIngredientRequestEntity>[];
      for (final item in items) {
        CaregiverSubstituteItemEntity? matched;
        for (final sub in item.substitutes) {
          if (sub.name.trim().toLowerCase() ==
              selectedSubstituteName.trim().toLowerCase()) {
            matched = sub;
            break;
          }
        }

        if (matched != null) {
          requests.add(
            CaregiverSwapIngredientRequestEntity(
              recipeId: item.recipeId,
              slot: item.slot,
              priority: matched.priority,
            ),
          );
        }
      }

      if (requests.isEmpty) {
        final revertedMap = Map<String, bool>.from(
          (state as CaregiverShoppingListLoaded).swapLoadingMap,
        )..[swapKey] = false;
        emit(currentState.copyWith(swapLoadingMap: revertedMap));
        return;
      }

      final result = await swapIngredientUseCase(requests);

      result.fold((failure) {
        final revertedMap = Map<String, bool>.from(
          (state as CaregiverShoppingListLoaded).swapLoadingMap,
        )..[swapKey] = false;

        emit(
          (state as CaregiverShoppingListLoaded).copyWith(
            swapLoadingMap: revertedMap,
          ),
        );
      }, (_) async => await fetchCaregiverDailyShop(childId));
    }
  }

  @override
  CaregiverShoppingListState? fromJson(Map<String, dynamic> json) {
    try {
      final checkedMapData = json['checkedMap'] as Map<String, dynamic>?;
      if (checkedMapData != null) {
        final checkedMap = checkedMapData.map(
          (key, value) => MapEntry(key, value as bool),
        );
        return CaregiverShoppingListLoaded(
          items: const [],
          checkedMap: checkedMap,
        );
      }
    } catch (_) {}
    return null;
  }

  @override
  Map<String, dynamic>? toJson(CaregiverShoppingListState state) {
    if (state is CaregiverShoppingListLoaded) {
      return {'checkedMap': state.checkedMap};
    }
    return null;
  }
}
