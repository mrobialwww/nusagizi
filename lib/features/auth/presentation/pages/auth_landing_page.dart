import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';

class AuthLandingPage extends StatefulWidget {
  const AuthLandingPage({super.key});

  @override
  State<AuthLandingPage> createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': AppImages.onboarding1,
      'title': 'Selamat Datang di Nusagizi!',
      'description':
          'Pantau tumbuh, kembang, dan kebutuhan gizi anak dalam satu aplikasi.',
    },
    {
      'image': AppImages.onboarding2,
      'title': 'Pantau Pertumbuhan Anak',
      'description':
          'Catat dan pantau berat badan, tinggi badan, dan lingkar kepala anak secara berkala.',
    },
    {
      'image': AppImages.onboarding3,
      'title': 'Rekomendasi Gizi Tepat',
      'description':
          'Dapatkan rekomendasi makanan dan gizi yang sesuai dengan usia dan kondisi anak.',
    },
    {
      'image': AppImages.onboarding4,
      'title': 'Konsultasi dengan Ahli',
      'description': 'Tanyakan langsung masalah gizi anak pada ahli gizi kami.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8F5E9), // Light green tint at the top
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // PageView Slider
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _onboardingData[index]['image']!,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            _onboardingData[index]['title']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _onboardingData[index]['description']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dot Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                    height: 8.0,
                    width: _currentPage == index ? 24.0 : 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF00A735) // Active green
                          : Colors.grey.shade300, // Inactive grey
                      borderRadius: BorderRadius.circular(4.0.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  children: [
                    // Masuk Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.login.name);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF00A735,
                          ), // Green color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Masuk',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Daftar Akun Baru Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.register.name);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF00A735),
                          ), // Green border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Daftar Akun Baru',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00A735),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
