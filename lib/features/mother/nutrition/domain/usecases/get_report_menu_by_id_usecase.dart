import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetReportMenuByIdUseCase {
  final NutritionRepository repository;

  GetReportMenuByIdUseCase(this.repository);

  Future<Either<Failure, DailyMenuEntity>> call(
    String childId,
    String reportId,
  ) async {
    return await repository.getReportMenuById(childId, reportId);
  }
}
