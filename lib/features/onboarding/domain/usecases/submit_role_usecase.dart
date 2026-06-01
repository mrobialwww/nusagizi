import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/onboarding/domain/repositories/onboarding_repository.dart';

class SubmitRoleUseCase implements UseCase<void, String> {
  final OnboardingRepository repository;

  SubmitRoleUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.submitRole(params);
  }
}
