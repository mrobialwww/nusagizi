import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const motherDestinations = [
  Destination(label: 'Home', icon: Icons.home_outlined),
  Destination(label: 'Explore', icon: Icons.search),
];
const caregiverDestinations = [
  Destination(label: 'Home', icon: Icons.home_outlined),
  Destination(label: 'Explore', icon: Icons.search),
];
const doctorDestinations = [
  Destination(label: 'Home', icon: Icons.home_outlined),
  Destination(label: 'Explore', icon: Icons.search),
];
