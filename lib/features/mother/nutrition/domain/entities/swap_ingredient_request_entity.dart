import 'package:equatable/equatable.dart';

class SwapIngredientRequestEntity extends Equatable {
  final String recipeId;
  final String slot;
  final int priority;

  const SwapIngredientRequestEntity({
    required this.recipeId,
    required this.slot,
    required this.priority,
  });

  @override
  List<Object?> get props => [recipeId, slot, priority];
}
