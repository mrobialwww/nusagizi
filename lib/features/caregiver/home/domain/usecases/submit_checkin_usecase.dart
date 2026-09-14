import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class SubmitCheckinUseCase implements UseCase<bool, String> {
  final CaregiverHomeRepository repository;

  SubmitCheckinUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String params) {
    return repository.submitCheckin(params);
  }
}
