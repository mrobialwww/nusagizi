import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class UpdateRecipeCompletionUseCase {
  final NutritionRepository repository;

  UpdateRecipeCompletionUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  ) {
    return repository.updateRecipeCompletion(recipeId, portionsConsumed, date);
  }
}
