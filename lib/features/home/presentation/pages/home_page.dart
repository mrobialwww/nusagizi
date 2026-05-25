import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Home page placeholder. Nanti akan dikembangkan sesuai role masing-masing.
class HomePage extends StatelessWidget {
  final String role;

  const HomePage({super.key, required this.role});

  String get _roleLabel {
    switch (role) {
      case 'mother':
        return 'Ibu (Mother)';
      case 'caregiver':
        return 'Pengasuh (Caregiver)';
      case 'doctor':
        return 'Dokter (Doctor)';
      default:
        return role;
    }
  }

  IconData get _roleIcon {
    switch (role) {
      case 'mother':
        return Icons.favorite_rounded;
      case 'caregiver':
        return Icons.child_care_rounded;
      case 'doctor':
        return Icons.medical_services_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF00C9A7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(_roleIcon, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 32),
                Text(
                  'Selamat Datang! 🎉',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _roleLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C63FF),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Kamu sudah berhasil masuk!\nHalaman ini akan dikembangkan lebih lanjut.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white38,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
