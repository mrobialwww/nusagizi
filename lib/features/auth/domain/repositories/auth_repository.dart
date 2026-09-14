import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/start_registration_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/verify_otp_and_login_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(LoginParams userLogin);

  Future<Either<Failure, UserEntity>> register(RegisterParams params);

  Future<Either<Failure, UserEntity>> googleLogin();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> startRegistration(
    StartRegistrationParams params,
  );

  Future<Either<Failure, UserEntity>> verifyOtpAndLogin(VerifyOtpParams params);

  Future<Either<Failure, void>> resendOtp(String email);
}
