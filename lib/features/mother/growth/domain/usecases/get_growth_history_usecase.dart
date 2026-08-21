import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';

class GetGrowthHistoryUseCase
    implements UseCase<List<LatestGrowthReportEntity>, String> {
  final GrowthRepository repository;

  GetGrowthHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<LatestGrowthReportEntity>>> call(
    String childId,
  ) async {
    return await repository.getGrowthHistory(childId);
  }
}
