import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';

abstract class SavedRecipeState extends Equatable {
  const SavedRecipeState();

  @override
  List<Object?> get props => [];
}

class SavedRecipeInitial extends SavedRecipeState {}

class SavedRecipeLoading extends SavedRecipeState {}

class SavedRecipeLoaded extends SavedRecipeState {
  final List<RecipeEntity> recipes;

  const SavedRecipeLoaded({required this.recipes});

  @override
  List<Object?> get props => [recipes];
}

class SavedRecipeError extends SavedRecipeState {
  final String message;

  const SavedRecipeError({required this.message});

  @override
  List<Object?> get props => [message];
}
