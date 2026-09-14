import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';

abstract class CaregiverShoppingListState extends Equatable {
  const CaregiverShoppingListState();

  @override
  List<Object?> get props => [];
}

class CaregiverShoppingListInitial extends CaregiverShoppingListState {}

class CaregiverShoppingListLoading extends CaregiverShoppingListState {}

class CaregiverShoppingListLoaded extends CaregiverShoppingListState {
  final List<CaregiverShoppingItemEntity> items;
  final Map<String, bool> checkedMap;

  // Using a separate map for swap loading state so we don't rebuild the entire UI awkwardly
  // key: recipeId_slot, value: true if loading
  final Map<String, bool> swapLoadingMap;

  const CaregiverShoppingListLoaded({
    required this.items,
    required this.checkedMap,
    this.swapLoadingMap = const {},
  });

  CaregiverShoppingListLoaded copyWith({
    List<CaregiverShoppingItemEntity>? items,
    Map<String, bool>? checkedMap,
    Map<String, bool>? swapLoadingMap,
  }) {
    return CaregiverShoppingListLoaded(
      items: items ?? this.items,
      checkedMap: checkedMap ?? this.checkedMap,
      swapLoadingMap: swapLoadingMap ?? this.swapLoadingMap,
    );
  }

  @override
  List<Object?> get props => [items, checkedMap, swapLoadingMap];
}

class CaregiverShoppingListError extends CaregiverShoppingListState {
  final String message;

  const CaregiverShoppingListError(this.message);

  @override
  List<Object?> get props => [message];
}
