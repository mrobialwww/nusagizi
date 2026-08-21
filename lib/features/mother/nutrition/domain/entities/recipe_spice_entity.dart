import 'package:equatable/equatable.dart';

class RecipeSpiceEntity extends Equatable {
  final String id;
  final String? recipeId;
  final String name;
  final String unit;

  const RecipeSpiceEntity({
    required this.id,
    this.recipeId,
    required this.name,
    required this.unit,
  });

  @override
  List<Object?> get props => [id, recipeId, name, unit];
}
