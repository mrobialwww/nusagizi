import 'package:equatable/equatable.dart';

class CaregiverSwapIngredientRequestEntity extends Equatable {
  final String recipeId;
  final String slot;
  final int priority;

  const CaregiverSwapIngredientRequestEntity({
    required this.recipeId,
    required this.slot,
    required this.priority,
  });

  @override
  List<Object?> get props => [recipeId, slot, priority];
}
