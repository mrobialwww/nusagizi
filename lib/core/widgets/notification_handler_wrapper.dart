import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/services/onesignal_service.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/router.dart';

class NotificationHandlerWrapper extends StatelessWidget {
  final Widget child;
  const NotificationHandlerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, current) =>
          prev is! AuthAuthenticated && current is AuthAuthenticated,
      listener: (context, state) {
        OneSignalService().setNotificationClickListener((event) {
          debugPrint("Push Clicked: ${event.notification.title}");
          final data = event.notification.additionalData;
          if (data == null) return;

          final action = data['action'] as String?;
          if (action == null) return;

          _handleNotificationRouting(context, action);
        });
      },
      child: child,
    );
  }

  void _handleNotificationRouting(BuildContext context, String action) {
    switch (action) {
      case 'open_growth':
        context.goNamed(AppRoutes.growth.name);
        break;
      case 'open_development':
        context.goNamed(AppRoutes.development.name);
        break;
      case 'open_social':
        context.goNamed(AppRoutes.socialMother.name);
        break;
      case 'open_review_photos':
        context.goNamed(AppRoutes.reviewPhotos.name);
        break;
      case 'open_home':
        context.goNamed(AppRoutes.homeCaregiver.name);
        break;
      case 'open_nutrition':
        context.goNamed(AppRoutes.nutrition.name);
        break;
    }
  }
}
