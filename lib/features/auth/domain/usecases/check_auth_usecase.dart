import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthUsecase {
  final AuthRepository repository;

  CheckAuthUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
