import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';
import 'package:nusagizi/router.dart';

/// Home page placeholder. Nanti akan dikembangkan sesuai role masing-masing.
class HomeMotherPage extends StatefulWidget {
  const HomeMotherPage({super.key});

  @override
  State<HomeMotherPage> createState() => _HomeMotherPageState();
}

class _HomeMotherPageState extends State<HomeMotherPage> {
  void _handleLogout() {
    context.read<AuthCubit>().logout();
  }

  Widget _buildAksesCepatItem({
    required String title,
    required String image,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal logout: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selamat Datang! 🎉',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "Mother",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Akses Cepat',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildAksesCepatItem(
                            title: 'Tumbuh',
                            image: AppImages.growth,
                            backgroundColor: const Color(0xFFE8F5E9),
                            textColor: const Color(0xFF2E7D32),
                            onTap: () => context.goNamed(AppRoutes.growth.name),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAksesCepatItem(
                            title: 'Kembang',
                            image: AppImages.development,
                            backgroundColor: const Color(0xFFE3F2FD),
                            textColor: const Color(0xFF1565C0),
                            onTap: () => context.goNamed(AppRoutes.development.name),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAksesCepatItem(
                            title: 'Gizi',
                            image: AppImages.nutrition,
                            backgroundColor: const Color(0xFFFFF3E0),
                            textColor: const Color(0xFFEF6C00),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : _handleLogout,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          foregroundColor: Colors.redAccent,
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent,
                                  ),
                                ),
                              )
                            : const Icon(Icons.logout_rounded, size: 18),
                        label: Text(
                          isLoading ? 'Mengeluarkan...' : 'Keluar',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
