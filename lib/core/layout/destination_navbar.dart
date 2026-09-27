import 'package:nusagizi/core/config/assets/app_vectors.dart';

class Destination {
  const Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String icon;
  final String selectedIcon;
}

const motherDestinations = [
  Destination(
    label: 'Home',
    icon: AppVectors.homeUnselected,
    selectedIcon: AppVectors.homeSelected,
  ),
  Destination(
    label: 'Catatan',
    icon: AppVectors.noteUnselected,
    selectedIcon: AppVectors.noteSelected,
  ),
  Destination(
    label: 'Sosial',
    icon: AppVectors.instagramUnselected,
    selectedIcon: AppVectors.instagramSelected,
  ),
  Destination(
    label: 'Profil',
    icon: AppVectors.userUnselected,
    selectedIcon: AppVectors.userSelected,
  ),
];
const caregiverDestinations = [
  Destination(
    label: 'Home',
    icon: AppVectors.homeUnselected,
    selectedIcon: AppVectors.homeSelected,
  ),
  Destination(
    label: 'Profil',
    icon: AppVectors.userUnselected,
    selectedIcon: AppVectors.userSelected,
  ),
];
const doctorDestinations = [
  Destination(
    label: 'Home',
    icon: AppVectors.homeUnselected,
    selectedIcon: AppVectors.homeSelected,
  ),
  Destination(
    label: 'Sosial',
    icon: AppVectors.instagramUnselected,
    selectedIcon: AppVectors.instagramSelected,
  ),
  Destination(
    label: 'Profil',
    icon: AppVectors.userUnselected,
    selectedIcon: AppVectors.userSelected,
  ),
];
