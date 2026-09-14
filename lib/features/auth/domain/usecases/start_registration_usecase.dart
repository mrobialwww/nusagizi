import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class StartRegistrationParams {
  final String username;
  final String email;
  final String password;

  const StartRegistrationParams({
    required this.username,
    required this.email,
    required this.password,
  });
}

class StartRegistrationUseCase {
  final AuthRepository repository;

  StartRegistrationUseCase({required this.repository});

  Future<Either<Failure, void>> call(StartRegistrationParams params) {
    return repository.startRegistration(params);
  }
}
