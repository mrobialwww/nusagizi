import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

class GoogleLoginUsecase {
  final AuthRepository repository;

  GoogleLoginUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.googleLogin();
  }
}
