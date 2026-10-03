import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/widgets/notification_handler_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/core/services/onesignal_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Lock orientation to portrait to prevent UI overflow on landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('id_ID', null);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  // FIX: Clear cache saat debugging agar perubahan alarm_dummy_data.dart terbaca
  await HydratedBloc.storage.clear();

  // Setup OneSignal
  OneSignalService().initialize("1f3f8347-97eb-4373-bcfc-8c83456a799a");

  // Request Access permission for notification
  OneSignalService().requestPermission();

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Builder(
        builder: (context) {
          final appRouter = AppRouter(authBloc: context.read<AuthCubit>());
          return ScreenUtilInit(
            designSize: const Size(412, 917),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'NusaGizi',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF6C63FF),
                  ),
                ),
                routerConfig: appRouter.router,
                builder: (context, child) =>
                    NotificationHandlerWrapper(child: child!),
              );
            },
          );
        },
      ),
    );
  }
}
