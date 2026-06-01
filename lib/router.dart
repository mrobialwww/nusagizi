import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/layout/caregiver_layout_scaffold.dart';
import 'package:nusagizi/core/layout/doctor_layout_scaffold.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/features/auth/presentation/pages/auth_landing_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/login_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/register_page.dart';
import 'package:nusagizi/features/caregiver/home/presentation/page/home_caregiver_page.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/page/profile_caregiver_page.dart';
import 'package:nusagizi/features/doctor/home/presentation/page/home_doctor_page.dart';
import 'package:nusagizi/features/doctor/profile/presentation/page/profile_doctor_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/checklist_milestone_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/development_history_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/development_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/development_profile_detail_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/kpsp_assessment_page.dart';
import 'package:nusagizi/features/mother/development/presentation/pages/kpsp_result_page.dart';
import 'package:nusagizi/features/mother/growth/presentation/pages/add_growth_page.dart';
import 'package:nusagizi/features/mother/growth/presentation/pages/growth_history_page.dart';
import 'package:nusagizi/features/mother/growth/presentation/pages/growth_page.dart';
import 'package:nusagizi/features/mother/home/presentation/pages/home_mother_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/profile_mother_page.dart';
import 'package:nusagizi/features/onboarding/presentation/pages/select_role_page.dart';
import 'package:nusagizi/features/splash/presentation/pages/splash_page.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';

import 'package:nusagizi/core/routes/route_args.dart';

// ENUM ROUTES (Best Practice untuk menghindari Magic Strings)
enum AppRoutes {
  splash,
  landing,
  login,
  register,
  selectRole,
  homeMother,
  homeCaregiver,
  homeDoctor,
  profileMother,
  profileCaregiver,
  profileDoctor,
  growth,
  growthHistory,
  growthAdd,
  development,
  developmentHistory,
  developmentKpsp,
  developmentKpspResult,
  developmentChecklist,
  developmentProfileDetail,
}

class AppRouter {
  final AuthCubit authBloc;

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(
          'Halaman tidak ditemukan!\n${state.uri.toString()}',
          textAlign: TextAlign.center,
        ),
      ),
    ),
    redirect: (context, state) {
      final authState = authBloc.state;

      final isGoingToSplash = state.matchedLocation == '/splash';
      final isGoingToAuth =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/landing';

      // Masih inisialisasi awal
      if (authState is AuthInitial) {
        return isGoingToSplash ? null : '/splash';
      }

      // Sedang proses loading (misal: saat tekan tombol login/register)
      if (authState is AuthLoading) {
        return null; // Biarkan user tetap di halaman saat ini agar UI menampilkan indikator loading
      }

      // Jika belum login, izinkan ke halaman auth, selain itu lempar ke landing page
      if (authState is AuthUnauthenticated ||
          authState is AuthError ||
          authState is AuthRegistered) {
        // Jika belum login, izinkan ke halaman auth, selain itu lempar ke landing page
        return isGoingToAuth ? null : '/landing';
      }

      // Jika sudah login, cek role
      if (authState is AuthAuthenticated) {
        final role = authState.user.role;

        if (role.isEmpty) {
          debugPrint(
            '[GoRouter Redirect] Role is EMPTY. Redirecting to /select-role',
          );
          // Belum milih role
          return state.matchedLocation == '/select-role'
              ? null
              : '/select-role';
        } else {
          debugPrint('[GoRouter Redirect] Role is NOT EMPTY: $role');
          // Sudah punya role
          final isGoingToForbiddenPage =
              isGoingToAuth ||
              isGoingToSplash ||
              state.matchedLocation == '/select-role';

          if (isGoingToForbiddenPage) {
            // Arahkan ke home yang sesuai dengan rolenya
            if (role == "mother") return '/home-mother';
            if (role == "caregiver") return '/home-caregiver';
            if (role == "doctor") return '/home-doctor';
          }

          return null;
        }
      }
      return null;
    },
    routes: [
      // ── Auth & Onboarding
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/landing',
        name: AppRoutes.landing.name,
        builder: (context, state) => const AuthLandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/select-role',
        name: AppRoutes.selectRole.name,
        builder: (context, state) => const SelectRolePage(),
      ),

      // ── Bottom Navigatino Bar (Mother)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MotherLayoutScaffold(navigationShell: navigationShell),
        branches: [
          // Branch 1: Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home-mother',
                name: AppRoutes.homeMother.name,
                builder: (context, state) => const HomeMotherPage(),
                routes: [
                  // ── Fitur: Tumbuh (Growth) ─────────────────────────────────────────────
                  GoRoute(
                    path: 'growth',
                    name: AppRoutes.growth.name,
                    builder: (context, state) => const GrowthPage(),
                    routes: [
                      GoRoute(
                        path: 'history',
                        name: AppRoutes.growthHistory.name,
                        builder: (context, state) {
                          final history = state.extra as List<GrowthRecord>;
                          return GrowthHistoryPage(history: history);
                        },
                      ),
                      GoRoute(
                        path: 'add',
                        name: AppRoutes.growthAdd.name,
                        builder: (context, state) => const AddGrowthPage(),
                      ),
                    ],
                  ),

                  // ── Fitur: Kembang (Development) ──────────────────────────────────────
                  GoRoute(
                    path: 'development',
                    name: AppRoutes.development.name,
                    builder: (context, state) => const DevelopmentPage(),
                    routes: [
                      GoRoute(
                        path: 'history',
                        name: AppRoutes.developmentHistory.name,
                        builder: (context, state) =>
                            const DevelopmentHistoryPage(),
                      ),
                      GoRoute(
                        path: 'kpsp',
                        name: AppRoutes.developmentKpsp.name,
                        builder: (context, state) {
                          final extra = state.extra as KpspAssessmentExtra;
                          return KpspAssessmentPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'kpsp-result',
                        name: AppRoutes.developmentKpspResult.name,
                        builder: (context, state) {
                          final extra = state.extra as KpspResultExtra;
                          return KpspResultPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                            questions: extra.questions,
                            answers: extra.answers,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'checklist',
                        name: AppRoutes.developmentChecklist.name,
                        builder: (context, state) {
                          final childAge = state.extra as String;
                          return ChecklistMilestonePage(childAge: childAge);
                        },
                      ),
                      GoRoute(
                        path: 'profile-detail',
                        name: AppRoutes.developmentProfileDetail.name,
                        builder: (context, state) {
                          final extra =
                              state.extra as DevelopmentProfileDetailExtra;
                          return DevelopmentProfileDetailPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                            motorikHalus: extra.motorikHalus,
                            motorikKasar: extra.motorikKasar,
                            sosialisasi: extra.sosialisasi,
                            bicara: extra.bicara,
                            motorikHalusStatus: extra.motorikHalusStatus,
                            motorikKasarStatus: extra.motorikKasarStatus,
                            sosialisasiStatus: extra.sosialisasiStatus,
                            bicaraStatus: extra.bicaraStatus,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Profile Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-mother',
                name: AppRoutes.profileMother.name,
                builder: (context, state) => const ProfileMotherPage(),
              ),
            ],
          ),
        ],
      ),

      // ── Bottom Navigatino Bar (Caregiver)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CaregiverLayoutScaffold(navigationShell: navigationShell),
        branches: [
          // Branch 1: Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home-caregiver',
                name: AppRoutes.homeCaregiver.name,
                builder: (context, state) => HomeCaregiverPage(),
              ),
            ],
          ),
          // Branch 2: Profile Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-caregiver',
                name: AppRoutes.profileCaregiver.name,
                builder: (context, state) => const ProfileCaregiverPage(),
              ),
            ],
          ),
        ],
      ),

      // ── Bottom Navigatino Bar (Doctor)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            DoctorLayoutScaffold(navigationShell: navigationShell),
        branches: [
          // Branch 1: Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home-doctor',
                name: AppRoutes.homeDoctor.name,
                builder: (context, state) => HomeDoctorPage(),
              ),
            ],
          ),
          // Branch 2: Profile Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-doctor',
                name: AppRoutes.profileDoctor.name,
                builder: (context, state) => const ProfileDoctorPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Menghubungkan AuthCubit stream ke GoRouter agar redirect otomatis (terpicu setiap kali AuthState berubah).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
