import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

// AUTH FEATURE - DOMAIN LAYER
// UseCase: business logic untuk login

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(LoginParams userLogin) async {
    return await repository.login(userLogin);
  }
}
