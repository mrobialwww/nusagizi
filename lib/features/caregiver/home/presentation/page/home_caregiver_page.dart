import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nusagizi/features/auth/presentation/cubit/auth_state.dart';

class HomeCaregiverPage extends StatefulWidget {
  const HomeCaregiverPage({super.key});

  @override
  State<HomeCaregiverPage> createState() => _HomeCaregiverPageState();
}

class _HomeCaregiverPageState extends State<HomeCaregiverPage> {
  void _handleLogout() {
    context.read<AuthCubit>().logout();
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
          body: Center(
            child: Column(
              children: [
                Text("CAREGIVER"),
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
        );
      },
    );
  }
}
