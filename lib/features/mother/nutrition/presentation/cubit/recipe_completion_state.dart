import 'package:equatable/equatable.dart';

abstract class RecipeCompletionState extends Equatable {
  const RecipeCompletionState();

  @override
  List<Object> get props => [];
}

class RecipeCompletionInitial extends RecipeCompletionState {}

class RecipeCompletionLoading extends RecipeCompletionState {}

class RecipeCompletionSuccess extends RecipeCompletionState {}

class RecipeCompletionError extends RecipeCompletionState {
  final String message;

  const RecipeCompletionError({required this.message});

  @override
  List<Object> get props => [message];
}
