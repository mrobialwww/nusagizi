import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class GetCaregiverChildrenSummaryUseCase
    implements UseCaseNoParams<List<ChildHeaderEntity>> {
  final CaregiverHomeRepository repository;

  GetCaregiverChildrenSummaryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChildHeaderEntity>>> call() async {
    return await repository.getChildrenSummary();
  }
}
