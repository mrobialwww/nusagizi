import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';

class AddGrowthReportUseCase implements UseCase<String, AddGrowthReportModel> {
  final GrowthRepository repository;

  AddGrowthReportUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddGrowthReportModel params) async {
    return await repository.addGrowthReport(params);
  }
}
