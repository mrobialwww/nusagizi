import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState();

  @override
  List<Object?> get props => [];
}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingItemEntity> items;
  final Map<String, bool> checkedMap;

  // Using a separate map for swap loading state so we don't rebuild the entire UI awkwardly
  // key: recipeId_slot, value: true if loading
  final Map<String, bool> swapLoadingMap;

  const ShoppingListLoaded({
    required this.items,
    required this.checkedMap,
    this.swapLoadingMap = const {},
  });

  ShoppingListLoaded copyWith({
    List<ShoppingItemEntity>? items,
    Map<String, bool>? checkedMap,
    Map<String, bool>? swapLoadingMap,
  }) {
    return ShoppingListLoaded(
      items: items ?? this.items,
      checkedMap: checkedMap ?? this.checkedMap,
      swapLoadingMap: swapLoadingMap ?? this.swapLoadingMap,
    );
  }

  @override
  List<Object?> get props => [items, checkedMap, swapLoadingMap];
}

class ShoppingListError extends ShoppingListState {
  final String message;

  const ShoppingListError(this.message);

  @override
  List<Object?> get props => [message];
}
