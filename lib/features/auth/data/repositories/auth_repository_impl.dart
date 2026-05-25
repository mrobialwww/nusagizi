import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// AUTH FEATURE - DATA LAYER
// Repository Implementation: implementasi dari domain/repository contract
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await remoteDataSource.login(email, password);
      final user = credentials.user;
      return Right(
        UserEntity(
          id: user.sub,
          name: user.name ?? '',
          email: user.email ?? '',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // TODO: implement getCurrentUser logic using auth0
      return Left(ServerFailure(message: 'Not implemented'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
