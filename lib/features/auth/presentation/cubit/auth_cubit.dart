import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';

// AUTH FEATURE - PRESENTATION LAYER
// Cubit: mengatur state dan memanggil use case
class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUseCase;
  final RegisterUsecase registerUseCase;
  final GoogleLoginUsecase googleLoginUseCase;
  final LogoutUsecase logoutUseCase;
  final CheckAuthUsecase checkAuthUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.logoutUseCase,
    required this.checkAuthUseCase,
  }) : super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    final LoginParams loginParams = LoginParams(
      email: email,
      password: password,
    );

    final result = await loginUseCase.call(loginParams);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final RegisterParams registerParams = RegisterParams(
      username: username,
      email: email,
      password: password,
    );

    final result = await registerUseCase.call(registerParams);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthRegistered()),
    );
  }

  Future<void> googleLogin() async {
    emit(const AuthLoading());

    final result = await googleLoginUseCase.call();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await logoutUseCase.call();
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> checkAuth() async {
    emit(const AuthLoading());
    final result = await checkAuthUseCase.call();
    
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void updateRole(String newRole) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedUser = UserEntity(
        id: currentState.user.id,
        username: currentState.user.username,
        email: currentState.user.email,
        role: newRole,
      );
      emit(AuthAuthenticated(user: updatedUser));
    }
  }
}
