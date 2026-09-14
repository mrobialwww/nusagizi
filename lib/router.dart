import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_qr_cubit.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/core/layout/caregiver_layout_scaffold.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/features/auth/presentation/pages/auth_landing_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/login_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/register_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/register_otp_screen.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/home_caregiver_page.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/caregiver_notification_page.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_home_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_children_cache_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_completion_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/caregiver_qr_page.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/caregiver_recipe_detail_page.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/caregiver_shopping_list_page.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/pages/profile_caregiver_page.dart';
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
import 'package:nusagizi/features/mother/profile/presentation/pages/add_or_edit_child_profile.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/profile_mother_page.dart';
import 'package:nusagizi/features/mother/social/presentation/pages/social_mother_page.dart';
import 'package:nusagizi/features/mother/social/presentation/pages/photo_memories_page.dart';
import 'package:nusagizi/features/mother/social/presentation/pages/photo_detail_page.dart';
import 'package:nusagizi/features/onboarding/presentation/pages/select_role_page.dart';
import 'package:nusagizi/features/splash/presentation/pages/splash_page.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/nutrition_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/all_menu_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/history_menu_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/nutrition_history_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/recipe_detail_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/saved_recipe_page.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/pages/shopping_list_page.dart';
import 'package:nusagizi/features/mother/home/presentation/pages/notification_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/edit_profile_page.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/pages/caregiver_edit_profile_page.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/security_account_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/child_profile_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/reminder_alarm_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/access_management_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/terms_and_conditions_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/access_history_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/help_center_page.dart';
import 'package:nusagizi/features/mother/profile/presentation/pages/language_settings_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:nusagizi/features/auth/presentation/pages/email_sent_page.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/note/presentation/pages/note_mother_page.dart';
import 'package:nusagizi/features/mother/note/presentation/pages/note_detail_page.dart';
import 'package:nusagizi/features/mother/note/presentation/pages/note_history_page.dart';
import 'package:nusagizi/features/mother/note/presentation/pages/add_edit_note_page.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/add_edit_note_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/pages/social_caregiver_page.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/photo_detail_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/pages/review_photos_page.dart';
import 'package:nusagizi/features/mother/social/presentation/pages/edit_child_photo_page.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/edit_child_photo_cubit.dart';

enum AppRoutes {
  splash,
  landing,
  login,
  register,
  registerOtp,
  authForgotPassword,
  authEmailSent,
  selectRole,
  homeMother,
  homeCaregiver,
  profileMother,
  profileCaregiver,
  noteMother,
  noteDetail,
  noteHistory,
  noteAddOrEdit,
  socialMother,
  photoMemories,
  photoDetail,
  reviewPhotos,
  editChildPhoto,
  sharePhoto,
  growth,
  growthHistory,
  growthAdd,
  development,
  developmentHistory,
  developmentKpsp,
  developmentKpspResult,
  developmentChecklist,
  developmentProfileDetail,
  nutrition,
  nutritionAllMenu,
  nutritionHistoryMenu,
  nutritionHistory,
  shoppingList,
  savedRecipe,
  recipeDetail,
  notification,
  editProfile,
  changePassword,
  childProfile,
  reminderAlarm,
  accessManagement,
  termsAndConditions,
  helpCenter,
  languageSettings,
  editChildProfile,
  forgotPassword,
  emailSent,
  detailDoctorNote,
  caregiverEditProfile,
  caregiverChangePassword,
  caregiverForgotPassword,
  caregiverEmailSent,
  caregiverNotification,
  caregiverQR,
  socialCaregiver,
  caregiverRecipeDetail,
  caregiverShoppingList,
  accessHistory,
}

class AppRouter {
  final AuthCubit authBloc;
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteObserver<ModalRoute<void>> rootRouteObserver =
      RouteObserver<ModalRoute<void>>();

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    observers: [rootRouteObserver],
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
          state.matchedLocation == '/otp' ||
          state.matchedLocation == '/landing' ||
          state.matchedLocation.startsWith('/auth-forgot-password');

      // Masih inisialisasi awal
      if (authState is AuthInitial) {
        return isGoingToSplash ? null : '/splash';
      }

      // Sedang proses loading (misal: saat tekan tombol login/register)
      if (authState is AuthLoading) {
        return null; // Biarkan user tetap di halaman saat ini agar UI menampilkan indikator loading
      }

      // Jika ada status OTP pending (menunggu verifikasi email)
      if (authState is AuthOtpPending) {
        return null; // Biarkan tetap di flow auth (layar OTP)
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
        path: '/otp',
        name: AppRoutes.registerOtp.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return RegisterOtpScreen(
            email: extra['email'] as String? ?? '',
            password: extra['password'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/select-role',
        name: AppRoutes.selectRole.name,
        builder: (context, state) => const SelectRolePage(),
      ),
      GoRoute(
        path: '/auth-forgot-password',
        name: AppRoutes.authForgotPassword.name,
        builder: (context, state) => ForgotPasswordPage(
          emailSentRouteName: AppRoutes.authEmailSent.name,
        ),
        routes: [
          GoRoute(
            path: 'email-sent',
            name: AppRoutes.authEmailSent.name,
            builder: (context, state) => const EmailSentPage(),
          ),
        ],
      ),

      // ── Bottom Navigation Bar (Mother)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MotherLayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home-mother',
                name: AppRoutes.homeMother.name,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          sl<MotherHomeCubit>()..getChildrenSummary(),
                    ),
                    BlocProvider(
                      create: (_) => sl<UserProfileCubit>()..loadProfile(),
                    ),
                  ],
                  child: const HomeMotherPage(),
                ),
                routes: [
                  // ── Fitur: Notifikasi ─────────────────────────────────────────────────
                  GoRoute(
                    path: 'notification',
                    name: AppRoutes.notification.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NotificationPage(),
                  ),

                  // ── Fitur: Tumbuh (Growth) ─────────────────────────────────────────────
                  GoRoute(
                    path: 'growth',
                    name: AppRoutes.growth.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.extra is String
                          ? state.extra as String
                          : null;
                      return GrowthPage(initialChildId: childId);
                    },
                    routes: [
                      GoRoute(
                        path: 'history',
                        name: AppRoutes.growthHistory.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final childId = state.extra as String;
                          return GrowthHistoryPage(childId: childId);
                        },
                      ),
                      GoRoute(
                        path: 'add',
                        name: AppRoutes.growthAdd.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final childId = state.extra as String;
                          return AddGrowthPage(childId: childId);
                        },
                      ),
                    ],
                  ),

                  // ── Fitur: Kembang (Development) ──────────────────────────────────────
                  GoRoute(
                    path: 'development',
                    name: AppRoutes.development.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.extra is String
                          ? state.extra as String
                          : null;
                      return DevelopmentPage(initialChildId: childId);
                    },
                    routes: [
                      GoRoute(
                        path: 'history',
                        name: AppRoutes.developmentHistory.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final selectedChild =
                              state.extra as ChildHeaderEntity?;
                          return DevelopmentHistoryPage(
                            selectedChild: selectedChild,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'kpsp',
                        name: AppRoutes.developmentKpsp.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as KpspAssessmentExtra;
                          return KpspAssessmentPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                            childId: extra.childId,
                            existingReportId: extra.existingReportId,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'kpsp-result',
                        name: AppRoutes.developmentKpspResult.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as KpspResultExtra;
                          return KpspResultPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                            reportId: extra.reportId,
                            isFromHistory: extra.isFromHistory,
                            childId: extra.childId,
                            showRetakeButton: extra.showRetakeButton,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'checklist',
                        name: AppRoutes.developmentChecklist.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as ChecklistMilestoneExtra;
                          return ChecklistMilestonePage(
                            childId: extra.childId,
                            childAge: extra.childAge,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'profile-detail',
                        name: AppRoutes.developmentProfileDetail.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra =
                              state.extra as DevelopmentProfileDetailExtra;
                          return DevelopmentProfileDetailPage(
                            childName: extra.childName,
                            childAge: extra.childAge,
                            childId: extra.childId,
                            reportId: extra.reportId,
                            motorikHalus: extra.motorikHalus,
                            motorikKasar: extra.motorikKasar,
                            sosialisasi: extra.sosialisasi,
                            bicara: extra.bicara,
                          );
                        },
                      ),
                    ],
                  ),

                  // ── Fitur: Gizi (Nutrition) ──────────────────────────────────────────
                  GoRoute(
                    path: 'nutrition',
                    name: AppRoutes.nutrition.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.extra is String
                          ? state.extra as String
                          : null;
                      return NutritionPage(initialChildId: childId);
                    },
                    routes: [
                      GoRoute(
                        path: 'all-menu',
                        name: AppRoutes.nutritionAllMenu.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as Map<String, dynamic>?;
                          return AllMenuPage(
                            childId: extra?['childId'] as String?,
                            reportId: extra?['reportId'] as String?,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'history-menu',
                        name: AppRoutes.nutritionHistoryMenu.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra =
                              state.extra as Map<String, dynamic>? ?? {};
                          return HistoryMenuPage(
                            childId: extra['childId'] as String?,
                            reportId: extra['reportId'] as String?,
                            dateStr: extra['dateStr'] as String?,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'history',
                        name: AppRoutes.nutritionHistory.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => NutritionHistoryPage(
                          child: state.extra as ChildHeaderEntity?,
                        ),
                      ),
                      GoRoute(
                        path: 'shopping-list',
                        name: AppRoutes.shoppingList.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => const ShoppingListPage(),
                      ),
                      GoRoute(
                        path: 'saved-recipes',
                        name: AppRoutes.savedRecipe.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final childId = state.extra is String
                              ? state.extra as String
                              : null;
                          return SavedRecipePage(childId: childId);
                        },
                      ),
                      GoRoute(
                        path: 'recipe-detail',
                        name: AppRoutes.recipeDetail.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final recipeId = state.extra as String?;
                          return RecipeDetailPage(recipeId: recipeId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/note-mother',
                name: AppRoutes.noteMother.name,
                builder: (context, state) => const NoteMotherPage(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    name: AppRoutes.noteDetail.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return NoteDetailPage(noteId: id);
                    },
                  ),
                  GoRoute(
                    path: 'history',
                    name: AppRoutes.noteHistory.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NoteHistoryPage(),
                  ),
                  GoRoute(
                    path: 'add-or-edit-note',
                    name: AppRoutes.noteAddOrEdit.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final noteToEdit =
                          state.extra as MedicalNoteDetailEntity?;
                      return BlocProvider(
                        create: (_) => sl<AddEditMedicalNoteCubit>(),
                        child: AddOrEditNotePage(noteToEdit: noteToEdit),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/social-mother',
                name: AppRoutes.socialMother.name,
                builder: (context, state) => const SocialMotherPage(),
                routes: [
                  GoRoute(
                    path: 'photo-memories',
                    name: AppRoutes.photoMemories.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.extra is String
                          ? state.extra as String
                          : null;
                      return PhotoMemoriesPage(childId: childId);
                    },
                  ),
                  GoRoute(
                    path: 'photo-detail',
                    name: AppRoutes.photoDetail.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final photoId = extra?['photoId'] as String?;
                      final imageUrl =
                          extra?['image'] as String? ?? AppImages.childHome1;
                      // Mengambil fungsi callback penutup bottom sheet yang dikirim dari galeri
                      final closeBottomSheet =
                          extra?['closeBottomSheet'] as VoidCallback?;
                      final galleryCubit =
                          extra?['galleryCubit'] as GalleryCubit?;

                      Widget page = BlocProvider(
                        create: (_) => sl<PhotoDetailCubit>(),
                        child: PhotoDetailPage(
                          photoId: photoId,
                          imageUrl: imageUrl,
                          closeBottomSheet: closeBottomSheet,
                        ),
                      );

                      if (galleryCubit != null) {
                        return BlocProvider.value(
                          value: galleryCubit,
                          child: page,
                        );
                      }

                      return page;
                    },
                  ),
                  GoRoute(
                    path: 'review-photos',
                    name: AppRoutes.reviewPhotos.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ReviewPhotosPage(),
                  ),
                  GoRoute(
                    path: 'edit-child-photo',
                    name: AppRoutes.editChildPhoto.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final photoId = extra?['photoId'] as String?;
                      final imageUrl =
                          extra?['image'] as String? ?? AppImages.childHome1;
                      final childId = extra?['childId'] as String?;

                      return BlocProvider(
                        create: (_) => sl<EditChildPhotoCubit>(),
                        child: EditChildPhotoPage(
                          photoId: photoId,
                          imageUrl: imageUrl,
                          childId: childId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-mother',
                name: AppRoutes.profileMother.name,
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<UserProfileCubit>()..loadProfile(),
                  child: const ProfileMotherPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'edit-profile',
                    name: AppRoutes.editProfile.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extra = state.extra as EditProfileExtra;
                      return BlocProvider.value(
                        value: extra.cubit,
                        child: EditProfilePage(initialProfile: extra.profile),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'security-account',
                    name: AppRoutes.changePassword.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SecurityAccountPage(),
                    routes: [
                      GoRoute(
                        path: 'forgot-password',
                        name: AppRoutes.forgotPassword.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => ForgotPasswordPage(
                          emailSentRouteName: AppRoutes.emailSent.name,
                        ),
                        routes: [
                          GoRoute(
                            path: 'email-sent',
                            name: AppRoutes.emailSent.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) => const EmailSentPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'child-profile',
                    name: AppRoutes.childProfile.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => BlocProvider(
                      create: (_) => sl<ChildProfileCubit>()..loadChildren(),
                      child: const ChildProfilePage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: AppRoutes.editChildProfile.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra;
                          ChildProfileEntity? childData;
                          bool fromHome = false;

                          if (extra is ChildProfileEntity) {
                            childData = extra;
                          } else if (extra is Map<String, dynamic>) {
                            fromHome = extra['fromHome'] as bool? ?? false;
                            childData =
                                extra['childData'] as ChildProfileEntity?;
                          }

                          return BlocProvider(
                            create: (_) {
                              final cubit = sl<AddEditProfileCubit>();
                              if (childData != null) {
                                cubit.loadChildDetail(childData.id);
                              }
                              return cubit;
                            },
                            child: AddOrEditChildProfile(
                              childData: childData,
                              fromHome: fromHome,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'reminder-alarm',
                    name: AppRoutes.reminderAlarm.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ReminderAlarmPage(),
                  ),
                  GoRoute(
                    path: 'access-management',
                    name: AppRoutes.accessManagement.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => BlocProvider(
                      create: (_) =>
                          sl<CaregiverEngagementCubit>()
                            ..loadActiveEngagements(),
                      child: const AccessManagementPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'access-history',
                        name: AppRoutes.accessHistory.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => BlocProvider(
                          create: (_) =>
                              sl<CaregiverEngagementCubit>()
                                ..loadRevokedEngagements(),
                          child: const AccessHistoryPage(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'terms-and-conditions',
                    name: AppRoutes.termsAndConditions.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const TermsAndConditionsPage(),
                  ),
                  GoRoute(
                    path: 'help-center',
                    name: AppRoutes.helpCenter.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const HelpCenterPage(),
                  ),
                  GoRoute(
                    path: 'language-settings',
                    name: AppRoutes.languageSettings.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const LanguageSettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Bottom Navigation Bar (Caregiver)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CaregiverLayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home-caregiver',
                name: AppRoutes.homeCaregiver.name,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => sl<CaregiverChildrenCacheCubit>(),
                    ),
                    BlocProvider(
                      create: (_) =>
                          sl<CaregiverHomeCubit>()..getChildrenSummary(),
                    ),
                    BlocProvider(create: (_) => sl<CaregiverTodayMenuCubit>()),
                    BlocProvider(
                      create: (_) => sl<CaregiverRecipeCompletionCubit>(),
                    ),
                    BlocProvider(
                      create: (_) => sl<CaregiverProfileCubit>()..loadProfile(),
                    ),
                  ],
                  child: const HomeCaregiverPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'notification',
                    name: AppRoutes.caregiverNotification.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const CaregiverNotificationPage(),
                  ),
                  GoRoute(
                    path: 'qr',
                    name: AppRoutes.caregiverQR.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => BlocProvider(
                      create: (_) => sl<CaregiverQRCubit>(),
                      child: const CaregiverQRPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'camera',
                    name: AppRoutes.socialCaregiver.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.extra as String? ?? "";
                      return CaregiverCameraPage(childId: childId);
                    },
                  ),
                  GoRoute(
                    path: 'recipe-detail',
                    name: AppRoutes.caregiverRecipeDetail.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final recipeId = state.extra as String? ?? "";
                      return CaregiverRecipeDetailPage(recipeId: recipeId);
                    },
                  ),
                  GoRoute(
                    path: 'shopping-list/:child_id',
                    name: AppRoutes.caregiverShoppingList.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final childId = state.pathParameters['child_id']!;
                      return CaregiverShoppingListPage(childId: childId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-caregiver',
                name: AppRoutes.profileCaregiver.name,
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<CaregiverProfileCubit>()..loadProfile(),
                  child: const ProfileCaregiverPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'edit-profile',
                    name: AppRoutes.caregiverEditProfile.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extra = state.extra as CaregiverEditProfileExtra;
                      return BlocProvider.value(
                        value: extra.cubit,
                        child: CaregiverEditProfilePage(
                          initialProfile: extra.profile,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'security-account',
                    name: AppRoutes.caregiverChangePassword.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SecurityAccountPage(),
                    routes: [
                      GoRoute(
                        path: 'forgot-password',
                        name: AppRoutes.caregiverForgotPassword.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => ForgotPasswordPage(
                          emailSentRouteName: AppRoutes.caregiverEmailSent.name,
                        ),
                        routes: [
                          GoRoute(
                            path: 'email-sent',
                            name: AppRoutes.caregiverEmailSent.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) => const EmailSentPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
