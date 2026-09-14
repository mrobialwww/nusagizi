import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';

abstract class RecipeDetailState extends Equatable {
  const RecipeDetailState();

  @override
  List<Object?> get props => [];
}

class RecipeDetailInitial extends RecipeDetailState {}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailLoaded extends RecipeDetailState {
  final RecipeDetailEntity recipeDetail;

  const RecipeDetailLoaded({required this.recipeDetail});

  @override
  List<Object?> get props => [recipeDetail];
}

class RecipeDetailError extends RecipeDetailState {
  final String message;

  const RecipeDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookmarkSuccess extends RecipeDetailState {
  final RecipeDetailEntity recipeDetail;
  const BookmarkSuccess({required this.recipeDetail});

  @override
  List<Object?> get props => [recipeDetail];
}

class BookmarkError extends RecipeDetailState {
  final RecipeDetailEntity recipeDetail;
  final String message;
  const BookmarkError({required this.recipeDetail, required this.message});

  @override
  List<Object?> get props => [recipeDetail, message];
}
