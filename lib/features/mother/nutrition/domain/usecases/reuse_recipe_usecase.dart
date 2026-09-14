import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class ReuseRecipeUseCase {
  final NutritionRepository repository;

  ReuseRecipeUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    String childId,
    String sourceRecipeId,
    DateTime date,
  ) {
    return repository.reuseRecipe(childId, sourceRecipeId, date);
  }
}
