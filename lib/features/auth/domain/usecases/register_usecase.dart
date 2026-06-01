import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';

// AUTH FEATURE - DOMAIN LAYER
// UseCase: business logic untuk register

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(params);
  }
}
