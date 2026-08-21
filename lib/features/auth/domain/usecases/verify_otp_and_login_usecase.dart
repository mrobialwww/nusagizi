import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  final String email;
  final String otpCode;
  final String password;

  const VerifyOtpParams({
    required this.email,
    required this.otpCode,
    required this.password,
  });
}

class VerifyOtpAndLoginUseCase {
  final AuthRepository repository;

  VerifyOtpAndLoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtpAndLogin(params);
  }
}
