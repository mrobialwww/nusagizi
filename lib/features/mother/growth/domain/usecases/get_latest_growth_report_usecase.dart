import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';

class GetLatestGrowthReportUseCase
    implements UseCase<LatestGrowthReportEntity, String> {
  final GrowthRepository repository;

  GetLatestGrowthReportUseCase({required this.repository});

  @override
  Future<Either<Failure, LatestGrowthReportEntity>> call(String params) {
    return repository.getLatestGrowthReport(params);
  }
}
