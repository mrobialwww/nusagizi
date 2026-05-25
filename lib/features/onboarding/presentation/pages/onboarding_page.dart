import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuzagizi/core/utils/jwt_utils.dart';
import 'package:nuzagizi/features/home/presentation/pages/home_page.dart';
import 'package:nuzagizi/features/onboarding/data/models/onboarding_model.dart';
import 'package:nuzagizi/features/onboarding/data/datasources/onboarding_remote_datasource.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _onboardingSource = OnboardingRemoteDataSource();

  String? _selectedRole;
  String? _selectedGender;
  bool _isLoading = false;

  final List<Map<String, String>> _roles = [
    {'value': 'mother', 'label': 'Ibu (Mother)'},
    {'value': 'caregiver', 'label': 'Pengasuh (Caregiver)'},
    {'value': 'doctor', 'label': 'Dokter (Doctor)'},
  ];

  final List<Map<String, String>> _genders = [
    {'value': 'male', 'label': 'Laki-laki'},
    {'value': 'female', 'label': 'Perempuan'},
  ];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih Peran dan Jenis Kelamin'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final int age = int.tryParse(_ageController.text) ?? 0;

    setState(() => _isLoading = true);

    try {
      final model = OnboardingModel(
        role: _selectedRole!,
        gender: _selectedGender!,
        age: age,
      );

      // Langkah 3 & 4 — Golang simpan DB + assign role ke Auth0
      await _onboardingSource.submitOnboarding(model);

      // Langkah 6 — Paksa refresh JWT agar claim role baru masuk
      final newCredentials = await _onboardingSource.refreshToken();

      if (mounted) {
        // Decode role dari JWT terbaru menggunakan JwtUtils
        final role = JwtUtils.decodeRole(newCredentials.accessToken);
        debugPrint('[Onboarding] Role setelah refresh: $role');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil disimpan!')),
        );

        // Navigasi ke HomePage berdasarkan role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(role: role),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Header
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF00C9A7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.5),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Lengkapi\nProfilmu 🚀',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih peranmu agar kami bisa menyesuaikan pengalamanmu',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Glass Card Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role Dropdown
                        _buildLabel('Peran (Role)'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          items: _roles,
                          value: _selectedRole,
                          hint: 'Pilih peran',
                          onChanged: (val) => setState(() => _selectedRole = val),
                        ),
                        const SizedBox(height: 20),

                        // Gender Dropdown
                        _buildLabel('Jenis Kelamin'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          items: _genders,
                          value: _selectedGender,
                          hint: 'Pilih jenis kelamin',
                          onChanged: (val) => setState(() => _selectedGender = val),
                        ),
                        const SizedBox(height: 20),

                        // Age Input
                        _buildLabel('Usia'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.outfit(color: Colors.white),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Usia wajib diisi';
                            if (int.tryParse(v) == null) return 'Usia harus berupa angka';
                            if (int.parse(v) <= 0) return 'Usia tidak valid';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukkan usia (contoh: 28)',
                            hintStyle: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.07),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Colors.redAccent.withOpacity(0.7),
                                width: 1.5,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6C63FF),
                                  ),
                                )
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF6C63FF),
                                        Color(0xFF00C9A7),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6C63FF).withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Selesai & Lanjutkan',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Widget _buildDropdown({
    required List<Map<String, String>> items,
    required String? value,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: GoogleFonts.outfit(color: Colors.white38)),
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2C),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']!),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
