import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class UpdateBookmarkRecipeUseCase {
  final NutritionRepository repository;

  UpdateBookmarkRecipeUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String recipeId, bool isBookmarked) {
    return repository.updateBookmarkRecipe(recipeId, isBookmarked);
  }
}
