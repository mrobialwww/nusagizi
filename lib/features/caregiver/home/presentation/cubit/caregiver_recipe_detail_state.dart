import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';

abstract class CaregiverRecipeDetailState extends Equatable {
  const CaregiverRecipeDetailState();

  @override
  List<Object> get props => [];
}

class CaregiverRecipeDetailInitial extends CaregiverRecipeDetailState {}

class CaregiverRecipeDetailLoading extends CaregiverRecipeDetailState {}

class CaregiverRecipeDetailLoaded extends CaregiverRecipeDetailState {
  final RecipeDetailEntity recipeDetail;

  const CaregiverRecipeDetailLoaded({required this.recipeDetail});

  @override
  List<Object> get props => [recipeDetail];
}

class CaregiverRecipeDetailError extends CaregiverRecipeDetailState {
  final String message;

  const CaregiverRecipeDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
