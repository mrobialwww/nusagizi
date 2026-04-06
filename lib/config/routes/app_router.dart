import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';

// Daftar semua route name
class Routes {
  static const String login = '/login';
  static const String home = '/home';
}

// Router aplikasi
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      // case Routes.home:
      //   return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
