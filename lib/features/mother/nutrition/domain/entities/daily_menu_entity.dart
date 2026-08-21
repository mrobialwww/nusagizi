import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';

class DailyMenuEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final List<RecipeEntity> recipes;

  const DailyMenuEntity({
    required this.id,
    required this.createdAt,
    required this.recipes,
  });

  @override
  List<Object?> get props => [id, createdAt, recipes];
}
