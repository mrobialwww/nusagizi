import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase({required this.repository});

  Future<Either<Failure, void>> call(String email) {
    return repository.resendOtp(email);
  }
}
