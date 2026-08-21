import 'package:equatable/equatable.dart';

abstract class CaregiverRecipeCompletionState extends Equatable {
  const CaregiverRecipeCompletionState();

  @override
  List<Object> get props => [];
}

class CaregiverRecipeCompletionInitial extends CaregiverRecipeCompletionState {}

class CaregiverRecipeCompletionLoading extends CaregiverRecipeCompletionState {}

class CaregiverRecipeCompletionSuccess extends CaregiverRecipeCompletionState {}

class CaregiverRecipeCompletionError extends CaregiverRecipeCompletionState {
  final String message;

  const CaregiverRecipeCompletionError({required this.message});

  @override
  List<Object> get props => [message];
}
