import 'package:equatable/equatable.dart';

class CookingStepEntity extends Equatable {
  final String id;
  final String? recipeId;
  final int stepNumber;
  final String instruction;
  final String imageUrl;

  const CookingStepEntity({
    required this.id,
    this.recipeId,
    required this.stepNumber,
    required this.instruction,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, recipeId, stepNumber, instruction, imageUrl];
}
