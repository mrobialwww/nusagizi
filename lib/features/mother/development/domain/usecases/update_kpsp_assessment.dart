import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class UpdateKpspAssessment implements UseCase<String, DevelopmentReportUpdateRequestModel> {
  final ChildDevelopmentRepository repository;

  UpdateKpspAssessment(this.repository);

  @override
  Future<Either<Failure, String>> call(DevelopmentReportUpdateRequestModel params) async {
    return await repository.updateDevelopmentReport(request: params);
  }
}