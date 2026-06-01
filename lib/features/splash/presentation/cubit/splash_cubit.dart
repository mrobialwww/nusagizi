import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/utils/jwt_utils.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final Auth0 _auth0;

  SplashCubit({required Auth0 auth0})
      : _auth0 = auth0,
        super(SplashInitial());

  /// Dipanggil setelah animasi splash selesai (~2 detik).
  /// Mengecek apakah ada session yang valid, lalu emit state routing yang sesuai.
  Future<void> checkAuthStatus() async {
    emit(SplashLoading());

    try {
      // Cek apakah ada credentials yang valid di storage
      final hasCredentials = await _auth0.credentialsManager
          .hasValidCredentials();

      if (!hasCredentials) {
        // Tidak ada session → ke Onboarding Slider
        debugPrint('[Splash] Tidak ada session valid → AuthLandingPage');
        emit(SplashNavigateToOnboardingSlider());
        return;
      }

      // Ada session → ambil credentials
      final credentials = await _auth0.credentialsManager.credentials();
      final accessToken = credentials.accessToken;

      // Cek apakah sudah onboarding (punya role di JWT)
      final hasRole = JwtUtils.hasRole(accessToken);
      debugPrint('[Splash] hasRole=$hasRole');

      if (!hasRole) {
        // Sudah login tapi belum onboarding (tidak punya role) → OnboardingPage
        debugPrint('[Splash] Belum onboarding (no role) → OnboardingPage');
        emit(SplashNavigateToOnboarding());
      } else {
        // Sudah login + sudah onboarding → ke HomePage dengan role
        final role = JwtUtils.decodeRole(accessToken);
        debugPrint('[Splash] Role=$role → HomePage');
        emit(SplashNavigateToHome(role));
      }
    } catch (e) {
      // Jika ada error (misal token corrupt), paksa ke LoginPage
      debugPrint('[Splash] Error saat cek auth: $e → LoginPage');
      emit(SplashNavigateToLogin());
    }
  }
}
