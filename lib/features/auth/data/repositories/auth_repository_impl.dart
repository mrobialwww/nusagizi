// AUTH FEATURE - DATA LAYER
// Repository Implementation: implementasi dari domain/repository contract
import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/utils/jwt_utils.dart';
import 'package:nusagizi/features/auth/data/datasources/auth_service.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;

  AuthRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterParams userRegister,
  ) async {
    try {
      final dbUser = await service.register(
        userRegister.email,
        userRegister.password,
        userRegister.username,
      );
      return Right(
        UserEntity(
          // Menggunakan email sebagai id fallback sementara jika Auth0 DatabaseUser
          // tidak langsung menyediakan id yang sama dengan token sub.
          id: dbUser.email,
          username: dbUser.username ?? userRegister.username,
          email: dbUser.email,
          role: '', // Register di Auth0 tidak mengembalikan token, jadi role kosong
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams userLogin) async {
    try {
      final credentials = await service.login(
        userLogin.email,
        userLogin.password,
      );
      final user = credentials.user;
      String role = JwtUtils.decodeRole(credentials.accessToken);
      
      final prefs = await SharedPreferences.getInstance();
      if (role.isEmpty) {
        role = prefs.getString('cached_role') ?? '';
      } else {
        await prefs.setString('cached_role', role);
      }

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> googleLogin() async {
    try {
      final credentials = await service.googleLogin();
      final user = credentials.user;
      String role = JwtUtils.decodeRole(credentials.accessToken);

      final prefs = await SharedPreferences.getInstance();
      if (role.isEmpty) {
        role = prefs.getString('cached_role') ?? '';
      } else {
        await prefs.setString('cached_role', role);
      }

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_role');
      
      await service.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final credentials = await service.getCurrentUser();
      if (credentials == null) {
        return Left(ServerFailure(message: 'No valid session'));
      }
      
      final user = credentials.user;
      String role = JwtUtils.decodeRole(credentials.accessToken);
      
      final prefs = await SharedPreferences.getInstance();
      if (role.isEmpty) {
        role = prefs.getString('cached_role') ?? '';
      } else {
        await prefs.setString('cached_role', role);
      }
      
      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
