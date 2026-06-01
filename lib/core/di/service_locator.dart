import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Imports
import 'package:nusagizi/features/auth/data/datasources/auth_service.dart';
import 'package:nusagizi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nusagizi/features/auth/domain/repositories/auth_repository.dart';
import 'package:nusagizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';

// Onboarding Imports
import 'package:nusagizi/features/onboarding/data/datasources/onboarding_local_service.dart';
import 'package:nusagizi/features/onboarding/data/datasources/onboarding_service.dart';

import 'package:nusagizi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:nusagizi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nusagizi/features/onboarding/domain/usecases/submit_role_usecase.dart';
import 'package:nusagizi/features/onboarding/presentation/cubit/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── External ──────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ─── Auth0 Singleton ───────────────────────────────────────────────────────
  sl.registerLazySingleton<Auth0>(
    () => Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!),
  );

  // ─── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(auth0: sl<Auth0>()),
  );

  sl.registerLazySingleton<OnboardingService>(
    () => OnboardingServiceImpl(auth0: sl<Auth0>()),
  );

  sl.registerLazySingleton<OnboardingLocalService>(
    () =>
        OnboardingLocalServiceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // ─── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: sl<AuthService>()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      remoteDataSource: sl<OnboardingService>(),
      localDataSource: sl<OnboardingLocalService>(),
    ),
  );

  // ─── Use Cases ─────────────────────────────────────────────────────────────
  // Auth Use Cases
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GoogleLoginUsecase>(
    () => GoogleLoginUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<CheckAuthUsecase>(
    () => CheckAuthUsecase(repository: sl<AuthRepository>()),
  );

  // Onboarding Use Cases
  sl.registerLazySingleton<SubmitRoleUseCase>(
    () => SubmitRoleUseCase(repository: sl<OnboardingRepository>()),
  );

  // ─── Cubits ────────────────────────────────────────────────────────────────
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl<LoginUsecase>(),
      registerUseCase: sl<RegisterUsecase>(),
      googleLoginUseCase: sl<GoogleLoginUsecase>(),
      logoutUseCase: sl<LogoutUsecase>(),
      checkAuthUseCase: sl<CheckAuthUsecase>(),
    ),
  );

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(submitRoleUseCase: sl<SubmitRoleUseCase>()),
  );
}
