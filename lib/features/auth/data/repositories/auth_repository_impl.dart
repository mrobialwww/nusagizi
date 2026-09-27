import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/utils/jwt_utils.dart';
import 'package:nusagizi/features/auth/data/datasources/auth_service.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/start_registration_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/verify_otp_and_login_usecase.dart';

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
          role:
              '', // Register di Auth0 tidak mengembalikan token, jadi role kosong
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
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
      // Role langsung diambil dari JWT — Auth0 Post-Login Action selalu menyertakan role claim.
      final String role = JwtUtils.decodeRole(credentials.accessToken);

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> googleLogin() async {
    try {
      final credentials = await service.googleLogin();

      // Jika null, artinya user menekan back/close — tidak ada error, abaikan saja.
      if (credentials == null) {
        return Left(CancelledFailure());
      }

      final user = credentials.user;
      // Role langsung diambil dari JWT.
      final String role = JwtUtils.decodeRole(credentials.accessToken);

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await service.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
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
      // Role langsung diambil dari JWT.
      final String role = JwtUtils.decodeRole(credentials.accessToken);

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> startRegistration(
    StartRegistrationParams params,
  ) async {
    try {
      // Langkah 1: Signup akun baru di Auth0 (username-password connection).
      // Menggunakan AuthService.register yang sudah ada (tidak duplikasi logika).
      await service.register(params.email, params.password, params.username);

      // Langkah 2: Kirim OTP ke email sebagai bukti kepemilikan email.
      await service.sendEmailVerificationOtp(email: params.email);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtpAndLogin(
    VerifyOtpParams params,
  ) async {
    try {
      // Langkah 3: Verifikasi OTP → dapat ID Token bukti kepemilikan email.
      final ownershipCredentials = await service.verifyEmailOwnership(
        email: params.email,
        otpCode: params.otpCode,
      );

      // Langkah 4: Kirim ID Token ke Gin → Gin tandai email_verified=true.
      await service.confirmEmailWithBackend(
        idToken: ownershipCredentials.idToken,
      );

      // Langkah 5: Login definitif pakai email+password (akun sudah terverifikasi).
      // Menggunakan AuthService.login yang sudah ada (tidak duplikasi logika).
      final credentials = await service.login(params.email, params.password);

      final user = credentials.user;
      final String role = JwtUtils.decodeRole(credentials.accessToken);

      return Right(
        UserEntity(
          id: user.sub,
          username: user.name ?? '',
          email: user.email ?? '',
          role: role,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      await service.sendEmailVerificationOtp(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
