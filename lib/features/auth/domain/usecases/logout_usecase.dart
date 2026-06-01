import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
