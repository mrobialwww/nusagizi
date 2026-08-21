import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_recipe_detail_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_detail_cubit.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_daily_shop_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/swap_caregiver_ingredient_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_shopping_list_cubit.dart';
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
import 'package:nusagizi/features/auth/domain/usecases/start_registration_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/verify_otp_and_login_usecase.dart';
import 'package:nusagizi/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';

// Onboarding Imports
import 'package:nusagizi/features/onboarding/data/datasources/onboarding_service.dart';

import 'package:nusagizi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:nusagizi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nusagizi/features/onboarding/domain/usecases/submit_role_usecase.dart';
import 'package:nusagizi/features/onboarding/presentation/cubit/onboarding_cubit.dart';

// Mother Home Imports
import 'package:nusagizi/features/mother/home/data/datasources/mother_home_service.dart';
import 'package:nusagizi/features/mother/home/data/repositories/mother_home_repository_impl.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/mother_home_repository.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_children_summary_usecase.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_cubit.dart';

// Caregiver Home Imports
import 'package:nusagizi/features/caregiver/home/data/datasources/caregiver_home_service.dart';
import 'package:nusagizi/features/caregiver/home/data/repositories/caregiver_home_repository_impl.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/update_caregiver_recipe_completion_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/fetch_child_preview_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/submit_checkin_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_today_menu_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_children_summary_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_qr_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_notification_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_completion_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_children_cache_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_home_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_cubit.dart';

// Mother Profile Imports
import 'package:nusagizi/features/mother/profile/data/datasources/mother_profile_service.dart';
import 'package:nusagizi/features/mother/profile/data/repositories/mother_profile_repository_impl.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/mother_profile_repository.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/generate_checkin_token_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/invite_access_cubit.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/child_profile_service.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';
import 'package:nusagizi/features/mother/profile/data/repositories/child_profile_repository_impl.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/add_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/update_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_child_detail_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_children_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/delete_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_form_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/user_profile_service.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/user_profile_repository.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/add_growth_report_usecase.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_history_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/add_growth_report_cubit.dart';
import 'package:nusagizi/features/mother/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_cubit.dart';

// Caregiver Profile Imports
import 'package:nusagizi/features/caregiver/profile/data/datasources/caregiver_profile_service.dart';
import 'package:nusagizi/features/caregiver/profile/data/repositories/caregiver_profile_repository_impl.dart';
import 'package:nusagizi/features/caregiver/profile/domain/repositories/caregiver_profile_repository.dart';
import 'package:nusagizi/features/caregiver/profile/domain/usecases/get_caregiver_profile_usecase.dart';
import 'package:nusagizi/features/caregiver/profile/domain/usecases/update_caregiver_profile_usecase.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';

// Notification Imports
import 'package:nusagizi/features/mother/home/data/datasources/notification_service.dart';
import 'package:nusagizi/features/mother/home/data/repositories/notification_repository_impl.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/notification_repository.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_all_notifications_usecase.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/notification_cubit.dart';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'package:nusagizi/features/mother/profile/data/datasources/caregiver_engagement_service.dart';
import 'package:nusagizi/features/mother/profile/data/repositories/caregiver_engagement_repository_impl.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/caregiver_engagement_repository.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_active_caregiver_engagements_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_revoked_caregiver_engagements_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/revoke_caregiver_engagement_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/caregiver_engagement_cubit.dart';

// Medical Notes Imports
import 'package:nusagizi/features/mother/note/data/datasources/note_service.dart';
import 'package:nusagizi/features/mother/note/data/repositories/note_repository_impl.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/get_medical_notes_usecase.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/get_medical_note_detail_usecase.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/add_medical_note_usecase.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/edit_medical_note_usecase.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_notes_cubit.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_note_detail_cubit.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/add_edit_note_cubit.dart';
// Latest Growth Report Imports
import 'package:nusagizi/features/mother/growth/data/datasources/child_growth_service.dart';
import 'package:nusagizi/features/mother/growth/data/repositories/growth_repository_impl.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_latest_growth_report_usecase.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_history_usecase.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_cubit.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_analyses_usecase.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/growth_analyses_cubit.dart';

// Development Imports
import 'package:nusagizi/features/mother/development/data/datasources/child_development_service.dart';
import 'package:nusagizi/features/mother/development/data/repositories/child_development_repository_impl.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_summary.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_history.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_report_detail.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_kpsp_questions.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/submit_kpsp_assessment.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/update_kpsp_assessment.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_development_recommendations.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_checklist_milestone_tasks.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/sync_checklist_milestone_progress.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_history_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_result_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_assessment_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_profile_detail_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/checklist_milestone_cubit.dart';

// Nutrition Imports
import 'package:nusagizi/features/mother/nutrition/data/datasources/child_nutrition_service.dart';
import 'package:nusagizi/features/mother/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_report_menu_by_id_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_nutrition_reports_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_nutrition_today_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_today_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_recipe_detail_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/update_bookmark_recipe_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_bookmarked_recipes_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/update_recipe_completion_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_history_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_detail_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_daily_shop_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/swap_ingredient_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/shopping_list_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/generate_menu_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/reuse_recipe_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/midnight_sync_cubit.dart';

// Image Upload Imports
import 'package:nusagizi/core/services/image_upload/data/datasources/image_api_service.dart';
import 'package:nusagizi/core/services/image_upload/data/datasources/image_storage_service.dart';
import 'package:nusagizi/core/services/image_upload/data/repositories/image_upload_repository_impl.dart';
import 'package:nusagizi/core/services/image_upload/domain/repositories/image_upload_repository.dart';
import 'package:nusagizi/core/services/image_upload/domain/usecases/upload_image_usecase.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_cubit.dart';

// Social Mother Imports
import 'package:nusagizi/features/mother/social/data/datasources/social_service.dart';
import 'package:nusagizi/features/mother/social/data/repositories/social_repository_impl.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_contacts_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/delete_contact_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_own_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_contact_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_all_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_photo_detail_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/create_child_photo_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/photo_detail_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/review_photos_cubit.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/edit_child_photo_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/edit_child_photo_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/create_child_photo_cubit.dart';

// Caregiver Social Imports
import 'package:nusagizi/features/caregiver/home/data/datasources/social_caregiver_remote_datasource.dart';
import 'package:nusagizi/features/caregiver/home/data/repositories/social_caregiver_repository_impl.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/social_caregiver_repository.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/create_caregiver_child_photo_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/create_caregiver_child_photo_cubit.dart';

final sl = GetIt.instance;

bool crudFlag = false;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Auth0 Singleton
  sl.registerLazySingleton<Auth0>(
    () => Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!),
  );

  // Dio Singleton
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] ?? ''));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final credentials = await sl<Auth0>().credentialsManager
                .credentials();
            options.headers['Authorization'] =
                'Bearer ${credentials.accessToken}';
          } on CredentialsManagerException catch (e) {
            // User is not logged in or session has expired â€” proceed without token.
            debugPrint('[Dio Interceptor] Credentials not found: ${e.message}');
          } catch (e, stack) {
            // Unexpected error while fetching token â€” reject the request.
            debugPrint('[Dio Interceptor] Unexpected error: $e\n$stack');
            return handler.reject(
              DioException(requestOptions: options, error: e),
            );
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  });

  // Storage Dio Singleton (No interceptors, plain Dio for PUTting to R2)
  sl.registerLazySingleton<Dio>(() => Dio(), instanceName: 'storageDio');

  // Image Upload Module
  sl.registerLazySingleton<ImageApiService>(
    () => ImageApiServiceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ImageStorageService>(
    () => ImageStorageServiceImpl(
      storageDio: sl<Dio>(instanceName: 'storageDio'),
    ),
  );
  sl.registerLazySingleton<ImageUploadRepository>(
    () => ImageUploadRepositoryImpl(
      apiService: sl<ImageApiService>(),
      storageService: sl<ImageStorageService>(),
    ),
  );
  sl.registerLazySingleton<UploadImageUseCase>(
    () => UploadImageUseCase(repository: sl<ImageUploadRepository>()),
  );
  sl.registerFactory<ImageUploadCubit>(
    () => ImageUploadCubit(uploadImageUseCase: sl<UploadImageUseCase>()),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(auth0: sl<Auth0>(), dio: sl<Dio>()),
  );

  sl.registerLazySingleton<OnboardingService>(
    () => OnboardingServiceImpl(auth0: sl<Auth0>()),
  );

  sl.registerLazySingleton<CaregiverHomeService>(
    () => CaregiverHomeServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<MotherHomeService>(
    () => MotherHomeServiceImpl(dio: sl()),
  );

  sl.registerLazySingleton<CaregiverEngagementService>(
    () => CaregiverEngagementServiceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MotherProfileService>(
    () => MotherProfileServiceImpl(dio: sl()),
  );
  sl.registerLazySingleton<UserProfileService>(
    () => UserProfileServiceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CaregiverProfileService>(
    () => CaregiverProfileServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ChildProfileService>(
    () => ChildProfileServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<NotificationService>(
    () => NotificationServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<NoteService>(
    () => NoteServiceImpl(dio: sl<Dio>()),
  ); // Repositories
  sl.registerLazySingleton<ChildDevelopmentService>(
    () => ChildDevelopmentServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: sl<AuthService>()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(service: sl<OnboardingService>()),
  );

  sl.registerLazySingleton<CaregiverHomeRepository>(
    () => CaregiverHomeRepositoryImpl(service: sl<CaregiverHomeService>()),
  );

  sl.registerLazySingleton<MotherHomeRepository>(
    () => MotherHomeRepositoryImpl(service: sl()),
  );

  sl.registerLazySingleton<CaregiverEngagementRepository>(
    () => CaregiverEngagementRepositoryImpl(service: sl()),
  );

  sl.registerLazySingleton<MotherProfileRepository>(
    () => MotherProfileRepositoryImpl(service: sl()),
  );
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(service: sl()),
  );
  sl.registerLazySingleton<CaregiverProfileRepository>(
    () =>
        CaregiverProfileRepositoryImpl(service: sl<CaregiverProfileService>()),
  );

  sl.registerLazySingleton<ChildProfileRepository>(
    () => ChildProfileRepositoryImpl(service: sl<ChildProfileService>()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(service: sl()),
  );

  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(service: sl()),
  );

  sl.registerLazySingleton<ChildDevelopmentRepository>(
    () => ChildDevelopmentRepositoryImpl(sl<ChildDevelopmentService>()),
  );

  sl.registerLazySingleton<ChildGrowthService>(
    () => ChildGrowthServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<GrowthRepository>(
    () => GrowthRepositoryImpl(service: sl()),
  );

  sl.registerLazySingleton<ChildNutritionService>(
    () => ChildNutritionServiceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(service: sl()),
  );

  // Use Cases
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
  sl.registerLazySingleton<StartRegistrationUseCase>(
    () => StartRegistrationUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpAndLoginUseCase>(
    () => VerifyOtpAndLoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(repository: sl<AuthRepository>()),
  );

  // Onboarding Use Cases
  sl.registerLazySingleton<SubmitRoleUseCase>(
    () => SubmitRoleUseCase(repository: sl<OnboardingRepository>()),
  );

  // Caregiver Home Use Cases
  sl.registerLazySingleton(
    () => GetCaregiverChildrenSummaryUseCase(
      repository: sl<CaregiverHomeRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => FetchChildPreviewUseCase(repository: sl<CaregiverHomeRepository>()),
  );
  sl.registerLazySingleton(
    () => SubmitCheckinUseCase(repository: sl<CaregiverHomeRepository>()),
  );
  sl.registerLazySingleton(
    () =>
        GetCaregiverTodayMenuUseCase(repository: sl<CaregiverHomeRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCaregiverRecipeDetailUseCase(
      repository: sl<CaregiverHomeRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateCaregiverRecipeCompletionUseCase(
      repository: sl<CaregiverHomeRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () =>
        GetCaregiverDailyShopUseCase(repository: sl<CaregiverHomeRepository>()),
  );
  sl.registerLazySingleton(
    () => SwapCaregiverIngredientUseCase(
      repository: sl<CaregiverHomeRepository>(),
    ),
  );

  // Mother Home Use Cases
  sl.registerLazySingleton(() => GetChildrenSummaryUseCase(repository: sl()));

  // Child Profile Use Cases
  sl.registerLazySingleton(() => AddChildProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateChildProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChildrenUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChildDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteChildProfileUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RevokeCaregiverEngagementUseCase(repository: sl()),
  );

  // Caregiver Engagements UseCases
  sl.registerLazySingleton(
    () => GetActiveCaregiverEngagementsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetRevokedCaregiverEngagementsUseCase(repository: sl()),
  );

  // Mother Profile Use Cases
  sl.registerLazySingleton<GenerateCheckinTokenUseCase>(
    () =>
        GenerateCheckinTokenUseCase(repository: sl<MotherProfileRepository>()),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCaregiverProfileUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => UpdateCaregiverProfileUseCase(repository: sl()),
  );

  // Notification Use Cases
  sl.registerLazySingleton<GetAllNotificationsUseCase>(
    () => GetAllNotificationsUseCase(repository: sl()),
  );

  sl.registerLazySingleton(() => GetMedicalNotesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMedicalNoteDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddMedicalNoteUseCase(sl()));
  sl.registerLazySingleton(() => EditMedicalNoteUseCase(sl()));

  sl.registerLazySingleton(
    () => GetLatestGrowthReportUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetGrowthHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddGrowthReportUseCase(sl()));
  sl.registerLazySingleton(() => GetGrowthAnalysesUseCase(sl()));

  sl.registerLazySingleton<GetChildDevelopmentSummary>(
    () => GetChildDevelopmentSummary(sl<ChildDevelopmentRepository>()),
  );
  sl.registerLazySingleton<GetChildDevelopmentHistory>(
    () => GetChildDevelopmentHistory(sl<ChildDevelopmentRepository>()),
  );

  sl.registerLazySingleton<GetNutritionReportsUseCase>(
    () => GetNutritionReportsUseCase(sl()),
  );

  sl.registerLazySingleton<GetReportMenuByIdUseCase>(
    () => GetReportMenuByIdUseCase(sl()),
  );
  sl.registerLazySingleton<GenerateMenuUseCase>(
    () => GenerateMenuUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetNutritionTodayUseCase>(
    () => GetNutritionTodayUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetDailyShopUseCase>(
    () => GetDailyShopUseCase(repository: sl()),
  );

  sl.registerLazySingleton<SwapIngredientUseCase>(
    () => SwapIngredientUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetRecipeDetailUseCase>(
    () => GetRecipeDetailUseCase(repository: sl()),
  );

  sl.registerLazySingleton<UpdateBookmarkRecipeUseCase>(
    () => UpdateBookmarkRecipeUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetBookmarkedRecipesUseCase>(
    () => GetBookmarkedRecipesUseCase(repository: sl()),
  );

  sl.registerLazySingleton<UpdateRecipeCompletionUseCase>(
    () => UpdateRecipeCompletionUseCase(repository: sl()),
  );

  sl.registerLazySingleton<ReuseRecipeUseCase>(
    () => ReuseRecipeUseCase(repository: sl()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl<LoginUsecase>(),
      registerUseCase: sl<RegisterUsecase>(),
      googleLoginUseCase: sl<GoogleLoginUsecase>(),
      logoutUseCase: sl<LogoutUsecase>(),
      checkAuthUseCase: sl<CheckAuthUsecase>(),
      startRegistrationUseCase: sl<StartRegistrationUseCase>(),
      verifyOtpAndLoginUseCase: sl<VerifyOtpAndLoginUseCase>(),
      resendOtpUseCase: sl<ResendOtpUseCase>(),
    ),
  );

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(submitRoleUseCase: sl<SubmitRoleUseCase>()),
  );

  sl.registerFactory<CaregiverQRCubit>(
    () => CaregiverQRCubit(
      fetchChildPreviewUseCase: sl<FetchChildPreviewUseCase>(),
      submitCheckinUseCase: sl<SubmitCheckinUseCase>(),
    ),
  );

  // Mother Home Cubits
  sl.registerLazySingleton(() => ChildrenCacheCubit());
  sl.registerFactory(
    () => MotherHomeCubit(
      getChildrenSummaryUseCase: sl(),
      cacheCubit: sl<ChildrenCacheCubit>(),
    ),
  );

  // Mother Profile (Caregiver Engagements)
  sl.registerFactory(
    () => CaregiverEngagementCubit(
      getActiveEngagementsUseCase: sl(),
      getRevokedEngagementsUseCase: sl(),
      revokeCaregiverEngagementUseCase: sl(),
    ),
  );

  sl.registerFactory<InviteAccessCubit>(
    () => InviteAccessCubit(
      generateCheckinTokenUseCase: sl<GenerateCheckinTokenUseCase>(),
    ),
  );

  sl.registerFactory(
    () => ChildProfileFormCubit(
      addChildProfileUseCase: sl(),
      updateChildProfileUseCase: sl(),
      deleteChildProfileUseCase: sl(),
      addGrowthReportUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ChildProfileCubit(getChildrenUseCase: sl()));

  sl.registerFactory(() => AddEditProfileCubit(getChildDetailUseCase: sl()));
  sl.registerFactory(
    () => UserProfileCubit(
      getUserProfileUseCase: sl(),
      updateUserProfileUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => CaregiverProfileCubit(
      getCaregiverProfileUseCase: sl(),
      updateCaregiverProfileUseCase: sl(),
    ),
  );

  sl.registerFactory(() => NotificationCubit(getAllNotificationsUseCase: sl()));

  sl.registerFactory(() => MedicalNotesCubit(getMedicalNotesUseCase: sl()));
  sl.registerFactory(
    () => MedicalNoteDetailCubit(getMedicalNoteDetailUseCase: sl()),
  );
  sl.registerFactory(
    () => AddEditMedicalNoteCubit(
      addMedicalNoteUseCase: sl(),
      editMedicalNoteUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => LatestGrowthReportCubit(getLatestGrowthReportUseCase: sl()),
  );
  sl.registerFactory(() => GrowthHistoryCubit(getGrowthHistoryUseCase: sl()));
  sl.registerFactory(() => AddGrowthReportCubit(addGrowthReportUseCase: sl()));
  sl.registerFactory(() => GrowthAnalysesCubit(sl()));

  // Child Development Use Cases
  sl.registerLazySingleton(() => GetChildDevelopmentReportDetail(sl()));
  sl.registerLazySingleton(
    () => GetKpspQuestions(sl<ChildDevelopmentRepository>()),
  );
  sl.registerLazySingleton(
    () => SubmitKpspAssessment(sl<ChildDevelopmentRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateKpspAssessment(sl<ChildDevelopmentRepository>()),
  );

  sl.registerLazySingleton(
    () => GetDevelopmentRecommendations(sl<ChildDevelopmentRepository>()),
  );

  sl.registerLazySingleton(
    () => GetChecklistMilestoneTasks(sl<ChildDevelopmentRepository>()),
  );
  sl.registerLazySingleton(
    () => SyncChecklistMilestoneProgress(sl<ChildDevelopmentRepository>()),
  );

  sl.registerFactory<DevelopmentCubit>(
    () => DevelopmentCubit(sl<GetChildDevelopmentSummary>()),
  );
  sl.registerFactory<DevelopmentHistoryCubit>(
    () => DevelopmentHistoryCubit(sl<GetChildDevelopmentHistory>()),
  );
  sl.registerFactory<KpspResultCubit>(
    () => KpspResultCubit(getReportDetail: sl()),
  );
  sl.registerFactory<KpspAssessmentCubit>(
    () => KpspAssessmentCubit(
      getKpspQuestions: sl<GetKpspQuestions>(),
      submitKpspAssessment: sl<SubmitKpspAssessment>(),
      updateKpspAssessment: sl<UpdateKpspAssessment>(),
    ),
  );
  sl.registerFactory<DevelopmentProfileDetailCubit>(
    () => DevelopmentProfileDetailCubit(
      getDevelopmentRecommendations: sl<GetDevelopmentRecommendations>(),
    ),
  );
  sl.registerFactory<ChecklistMilestoneCubit>(
    () => ChecklistMilestoneCubit(
      getChecklistMilestoneTasks: sl<GetChecklistMilestoneTasks>(),
      syncChecklistMilestoneProgress: sl<SyncChecklistMilestoneProgress>(),
    ),
  );

  sl.registerFactory(
    () => NutritionHistoryCubit(getNutritionReportsUseCase: sl()),
  );

  sl.registerFactory(
    () => DailyMenuCubit(
      getReportMenuByIdUseCase: sl(),
      getNutritionTodayUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => MenuActionCubit(
      generateMenuUseCase: sl(),
      reuseRecipeUseCase: sl(),
      shoppingListCubit: sl(),
      caregiverShoppingListCubit: sl(),
    ),
  );
  sl.registerLazySingleton(() => MidnightSyncCubit());
  sl.registerFactory(
    () => RecipeDetailCubit(
      getRecipeDetailUseCase: sl(),
      updateBookmarkRecipeUseCase: sl(),
    ),
  );
  sl.registerFactory(() => NutritionTodayCubit(getNutritionTodayUseCase: sl()));

  sl.registerFactory(
    () => ShoppingListCubit(
      getDailyShopUseCase: sl(),
      swapIngredientUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => SavedRecipeCubit(
      getBookmarkedRecipesUseCase: sl(),
      updateBookmarkRecipeUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RecipeCompletionCubit(updateRecipeCompletionUseCase: sl()),
  );

  sl.registerFactory(
    () => CaregiverNotificationCubit(getAllNotificationsUseCase: sl()),
  );

  sl.registerLazySingleton(() => CaregiverChildrenCacheCubit());

  sl.registerFactory(
    () => CaregiverHomeCubit(getChildrenSummaryUseCase: sl(), cacheCubit: sl()),
  );

  sl.registerFactory(
    () => CaregiverRecipeCompletionCubit(
      updateCaregiverRecipeCompletionUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CaregiverTodayMenuCubit(getCaregiverTodayMenuUseCase: sl()),
  );

  sl.registerFactory(
    () => CaregiverRecipeDetailCubit(getCaregiverRecipeDetailUseCase: sl()),
  );

  sl.registerFactory(
    () => CaregiverShoppingListCubit(
      getDailyShopUseCase: sl(),
      swapIngredientUseCase: sl(),
    ),
  );

  // Social Caregiver Module
  sl.registerLazySingleton<SocialCaregiverRemoteDataSource>(
    () => SocialCaregiverRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<SocialCaregiverRepository>(
    () => SocialCaregiverRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateCaregiverChildPhotoUseCase(sl()));
  sl.registerFactory(
    () => CreateCaregiverChildPhotoCubit(
      uploadImageUseCase: sl(),
      createCaregiverChildPhotoUseCase: sl(),
    ),
  );

  // Social Mother Module
  sl.registerLazySingleton<SocialService>(
    () => SocialServiceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<SocialRepository>(
    () => SocialRepositoryImpl(remoteDataSource: sl<SocialService>()),
  );

  sl.registerLazySingleton(() => GetContactsUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteContactUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllChildPhotosUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOwnChildPhotosUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetContactChildPhotosUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetPhotoDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => EditChildPhotoUseCase(sl()));
  sl.registerLazySingleton(() => CreateChildPhotoUseCase(sl()));

  sl.registerFactory(
    () => ContactsCubit(getContactsUseCase: sl(), deleteContactUseCase: sl()),
  );
  sl.registerFactory(
    () => GalleryCubit(
      getAllChildPhotosUseCase: sl(),
      getOwnChildPhotosUseCase: sl(),
      getContactChildPhotosUseCase: sl(),
    ),
  );
  sl.registerFactory(() => PhotoDetailCubit(getPhotoDetailUseCase: sl()));
  sl.registerFactory(() => EditChildPhotoCubit(editChildPhotoUseCase: sl()));
  sl.registerFactory(() => ReviewPhotosCubit(sl()));
  sl.registerFactory(
    () => CreateChildPhotoCubit(
      uploadImageUseCase: sl(),
      createChildPhotoUseCase: sl(),
    ),
  );
}
