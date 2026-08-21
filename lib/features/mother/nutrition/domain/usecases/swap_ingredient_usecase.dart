import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/swap_ingredient_request_entity.dart';

class SwapIngredientUseCase
    implements UseCase<void, List<SwapIngredientRequestEntity>> {
  final NutritionRepository repository;

  SwapIngredientUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
    List<SwapIngredientRequestEntity> params,
  ) async {
    return await repository.swapIngredient(params);
  }
}
