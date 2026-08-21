import 'package:equatable/equatable.dart';

class MainIngredientEntity extends Equatable {
  final String id;
  final String? recipeId;
  final String? ingredientId;
  final String name;
  final String unit;
  final int priority;
  final String slot;
  final String? imageUrl;

  const MainIngredientEntity({
    required this.id,
    this.recipeId,
    this.ingredientId,
    required this.name,
    required this.unit,
    required this.priority,
    required this.slot,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    recipeId,
    ingredientId,
    name,
    unit,
    priority,
    slot,
    imageUrl,
  ];
}
