part of 'splash_cubit.dart';

abstract class SplashState {}

/// State awal saat splash baru dibuka
class SplashInitial extends SplashState {}

/// Loading / sedang mengecek session
class SplashLoading extends SplashState {}

/// Tidak ada session → arahkan ke Onboarding Slider (atau LoginPage)
class SplashNavigateToLogin extends SplashState {}

/// Tidak ada session dan pengguna baru → arahkan ke Onboarding Slider
class SplashNavigateToOnboardingSlider extends SplashState {}

/// Ada session, tapi belum onboarding → arahkan ke SelectRolePage
class SplashNavigateToOnboarding extends SplashState {}

/// Ada session + sudah onboarding → arahkan ke HomePage
class SplashNavigateToHome extends SplashState {
  final String role;
  SplashNavigateToHome(this.role);
}
