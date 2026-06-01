import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
          return MaterialApp.router(
            title: 'NusaGizi',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
            ),
            routerConfig: appRouter.router,
          );
        }
      ),
    );
  }
}
