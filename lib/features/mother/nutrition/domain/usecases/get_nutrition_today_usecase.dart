import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetNutritionTodayUseCase {
  final NutritionRepository repository;

  GetNutritionTodayUseCase({required this.repository});

  Future<Either<Failure, NutritionTodayEntity>> call(
    String childId,
    DateTime date,
  ) {
    return repository.getNutritionToday(childId, date);
  }
}
