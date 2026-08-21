import 'package:dartz/dartz.dart';

import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class UpdateCaregiverRecipeCompletionUseCase {
  final CaregiverHomeRepository repository;

  UpdateCaregiverRecipeCompletionUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  ) async {
    return await repository.updateCaregiverRecipeCompletion(
      recipeId,
      portionsConsumed,
      date,
    );
  }
}
