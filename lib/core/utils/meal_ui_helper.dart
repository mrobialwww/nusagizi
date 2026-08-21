import 'package:flutter/material.dart';

class MealUiProfile {
  final String mealType;
  final String timeStr;
  final IconData icon;
  final Color iconColor;

  MealUiProfile({
    required this.mealType,
    required this.timeStr,
    required this.icon,
    required this.iconColor,
  });
}

class MealUiHelper {
  static MealUiProfile getProfile(String rawMealTime) {
    switch (rawMealTime.toLowerCase()) {
      case 'breakfast':
        return MealUiProfile(
          icon: Icons.wb_sunny_outlined,
          iconColor: const Color(0xFFF57C00),
          mealType: "Sarapan",
          timeStr: "07.00 - 08.00",
        );
      case 'lunch':
        return MealUiProfile(
          icon: Icons.wb_twilight,
          iconColor: const Color(0xFFF57C00),
          mealType: "Makan Siang",
          timeStr: "12.00 - 13.00",
        );
      case 'afternoon_snack':
        return MealUiProfile(
          icon: Icons.apple,
          iconColor: const Color(0xFFF44336),
          mealType: "Selingan Sore",
          timeStr: "15.00 - 16.00",
        );
      case 'dinner':
        return MealUiProfile(
          icon: Icons.nights_stay_outlined,
          iconColor: const Color(0xFF1976D2),
          mealType: "Makan Malam",
          timeStr: "18.00 - 19.00",
        );
      case 'morning_snack':
        return MealUiProfile(
          icon: Icons.apple,
          iconColor: const Color(0xFFF44336),
          mealType: "Selingan Pagi",
          timeStr: "10.00 - 11.00",
        );
      default:
        return MealUiProfile(
          icon: Icons.local_dining_outlined,
          iconColor: const Color(0xFF4CAF50),
          mealType: rawMealTime,
          timeStr: "00.00 - 00.00",
        );
    }
  }
}
