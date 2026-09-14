import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetChildDevelopmentReportDetail
    implements UseCase<ChildDevelopmentReportDetailEntity, String> {
  const GetChildDevelopmentReportDetail(this.repository);

  final ChildDevelopmentRepository repository;

  @override
  Future<Either<Failure, ChildDevelopmentReportDetailEntity>> call(
    String reportId,
  ) async {
    return repository.getDevelopmentReportDetail(reportId: reportId);
  }
}
