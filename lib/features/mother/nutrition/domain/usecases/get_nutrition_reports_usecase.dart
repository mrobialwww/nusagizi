import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_report_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetNutritionReportsUseCase {
  final NutritionRepository repository;

  GetNutritionReportsUseCase(this.repository);

  Future<Either<Failure, List<NutritionReportEntity>>> call(
    String childId,
    int month,
    int year,
  ) async {
    return await repository.getNutritionReports(childId, month, year);
  }
}
