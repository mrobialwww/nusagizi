import 'package:dartz/dartz.dart';

import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';

class GetCaregiverRecipeDetailUseCase
    implements UseCase<RecipeDetailEntity, String> {
  final CaregiverHomeRepository repository;

  GetCaregiverRecipeDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, RecipeDetailEntity>> call(String recipeId) async {
    return await repository.fetchCaregiverRecipeDetail(recipeId);
  }
}
