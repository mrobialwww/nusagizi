import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class SubmitKpspAssessment implements UseCase<String, DevelopmentReportCreateRequestModel> {
  final ChildDevelopmentRepository repository;

  SubmitKpspAssessment(this.repository);

  @override
  Future<Either<Failure, String>> call(DevelopmentReportCreateRequestModel params) async {
    return await repository.createDevelopmentReport(request: params);
  }
}