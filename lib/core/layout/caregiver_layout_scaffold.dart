import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/data/models/destination_navbar.dart';

/// Notifier untuk mengontrol tab aktif pada bottom nav bar Caregiver secara global.
final ValueNotifier<int> caregiverNavTabNotifier = ValueNotifier(0);

class CaregiverLayoutScaffold extends StatelessWidget {
  const CaregiverLayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('CaregiverLayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          caregiverNavTabNotifier.value = index;
          navigationShell.goBranch(index);
        },
        destinations: caregiverDestinations
            .map(
              (destination) => NavigationDestination(
                icon: SvgPicture.asset(destination.icon, width: 30, height: 30),
                label: destination.label,
                selectedIcon: SvgPicture.asset(
                  destination.selectedIcon,
                  width: 30,
                  height: 30,
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}
