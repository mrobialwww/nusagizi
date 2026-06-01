import 'package:dartz/dartz.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

// AUTH FEATURE - DOMAIN LAYER
// Repository: contract/interface, implementasinya ada di data layer
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(LoginParams userLogin);

  Future<Either<Failure, UserEntity>> register(RegisterParams params);

  Future<Either<Failure, UserEntity>> googleLogin();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
