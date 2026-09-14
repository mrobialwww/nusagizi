import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetRecipeDetailUseCase implements UseCase<RecipeDetailEntity, String> {
  final NutritionRepository repository;

  GetRecipeDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, RecipeDetailEntity>> call(String params) {
    return repository.getRecipeDetail(params);
  }
}
