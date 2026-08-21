import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/data/models/destination_navbar.dart';

final ValueNotifier<bool> hideMotherNavBarNotifier = ValueNotifier(false);
/// Notifier untuk mengontrol tab aktif pada bottom nav bar Mother secara global.
/// Gunakan [motherNavTabNotifier.value = index] untuk berpindah tab.
final ValueNotifier<int> motherNavTabNotifier = ValueNotifier(0);

class MotherLayoutScaffold extends StatelessWidget {
  const MotherLayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('MotherLayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: ValueListenableBuilder<bool>(
      valueListenable: hideMotherNavBarNotifier,
      builder: (context, hide, child) {
        return Container(
          decoration: BoxDecoration(
            color: hide ? const Color(0xFF1E1E1E) : Colors.white,
            boxShadow: hide
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
          ),
          child: IgnorePointer(
            ignoring: hide,
            child: Opacity(
              opacity: hide ? 0.0 : 1.0,
              child: NavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) {
                  motherNavTabNotifier.value = index;
                  navigationShell.goBranch(index);
                },
                destinations: motherDestinations
                    .map(
                      (destination) => NavigationDestination(
                        icon: SvgPicture.asset(destination.icon,
                            width: 30, height: 30),
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
          ),
        );
      },
    ),
  );
}
