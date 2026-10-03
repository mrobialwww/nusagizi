import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/start_registration_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/verify_otp_and_login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/features/auth/domain/entities/user_entity.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/core/services/onesignal_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUseCase;
  final RegisterUsecase registerUseCase;
  final GoogleLoginUsecase googleLoginUseCase;
  final LogoutUsecase logoutUseCase;
  final CheckAuthUsecase checkAuthUseCase;
  final StartRegistrationUseCase startRegistrationUseCase;
  final VerifyOtpAndLoginUseCase verifyOtpAndLoginUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.logoutUseCase,
    required this.checkAuthUseCase,
    required this.startRegistrationUseCase,
    required this.verifyOtpAndLoginUseCase,
    required this.resendOtpUseCase,
  }) : super(const AuthInitial());

  /// Hook terpusat — terpicu TEPAT SATU KALI setiap kali state berubah.
  /// Semua side-effect OneSignal dikelola di sini sehingga tidak tersebar.
  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    final next = change.nextState;

    if (next is AuthAuthenticated) {
      OneSignalService().login(next.user.id);
    } else if (next is AuthUnauthenticated) {
      OneSignalService().logout();
    }
  }

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

  /// Langkah 1+2: Signup akun baru di Auth0 + kirim OTP ke email.
  /// Jika berhasil, emit [AuthOtpPending] — sinyal untuk UI agar navigasi ke layar verifikasi OTP.
  /// Password diteruskan via state agar tersedi untuk login definitif di [verifyOtpAndLogin] (tidak pernah ditulis ke disk).
  Future<void> startRegistration({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final params = StartRegistrationParams(
      username: username,
      email: email,
      password: password,
    );

    final result = await startRegistrationUseCase.call(params);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthOtpPending(email: email, password: password)),
    );
  }

  /// Langkah 3+4+5: Verifikasi OTP → konfirmasi email ke Gin → login definitif.
  /// Jika berhasil, emit [AuthAuthenticated] — GoRouter akan redirect ke role-selection.
  Future<void> verifyOtpAndLogin({
    required String email,
    required String otpCode,
    required String password,
  }) async {
    emit(const AuthLoading());

    final params = VerifyOtpParams(
      email: email,
      otpCode: otpCode,
      password: password,
    );

    final result = await verifyOtpAndLoginUseCase.call(params);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Kirim ulang OTP ke email yang sama.
  Future<void> resendOtp({required String email}) async {
    final result = await resendOtpUseCase.call(email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => null, // sukses: state tidak berubah, UI OTP tetap tampil
    );
  }

  Future<void> googleLogin() async {
    final previousState = state;
    emit(const AuthLoading());

    final result = await googleLoginUseCase.call();

    result.fold((failure) {
      // Jika user cancel (back/close dari browser), kembalikan ke state sebelumnya
      // tanpa menampilkan error apapun.
      if (failure is CancelledFailure) {
        emit(previousState);
        return;
      }
      emit(AuthError(message: failure.message));
    }, (user) => emit(AuthAuthenticated(user: user)));
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await logoutUseCase.call();

    result.fold((failure) => emit(AuthError(message: failure.message)), (_) {
      sl<ChildrenCacheCubit>().save([]);
      emit(const AuthUnauthenticated());
    });
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
