import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/data/models/destination_navbar.dart';

class MotherLayoutScaffold extends StatelessWidget {
  const MotherLayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('MotherLayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: navigationShell.goBranch,
      indicatorColor: Theme.of(context).primaryColor,
      destinations: motherDestinations
          .map(
            (destination) => NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
              selectedIcon: Icon(destination.icon, color: Colors.white),
            ),
          )
          .toList(),
    ),
  );
}
