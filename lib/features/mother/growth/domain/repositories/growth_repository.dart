import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_analyses_usecase.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';

abstract class GrowthRepository {
  Future<Either<Failure, LatestGrowthReportEntity>> getLatestGrowthReport(
    String childId,
  );

  Future<Either<Failure, List<LatestGrowthReportEntity>>> getGrowthHistory(
    String childId,
  );

  Future<Either<Failure, String>> addGrowthReport(AddGrowthReportModel model);

  Future<Either<Failure, GrowthAnalysesEntity>> getGrowthAnalyses(
    GrowthAnalysesParams params,
  );
}
