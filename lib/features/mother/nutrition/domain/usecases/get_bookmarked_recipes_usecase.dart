import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetBookmarkedRecipesUseCase
    implements UseCase<List<RecipeEntity>, String> {
  final NutritionRepository repository;

  GetBookmarkedRecipesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(String childId) {
    return repository.getBookmarkedRecipes(childId);
  }
}
