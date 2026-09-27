import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const HeaderBasic(
        title: 'Syarat & Ketentuan',
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Banner Alert
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: const Color(0xFF0C9C48),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12.sp,
                            color: const Color(0xFF0C9C48),
                            height: 1.5,
                          ),
                          children: const [
                            TextSpan(text: "Terakhir diperbarui: "),
                            TextSpan(
                              text: "1 Januari 2026",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  ". Harap baca ketentuan ini dengan seksama sebelum menggunakan layanan kami.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Item 1
              _buildTermsCard(
                title: "Penerimaan Syarat",
                description:
                    "Dengan menggunakan Nusagizi, Anda menyetujui syarat dan ketentuan ini. Jika Anda tidak menyetujui ketentuan ini, harap hentikan penggunaan aplikasi.",
              ),
              SizedBox(height: 16.h),

              // Item 2
              _buildTermsCard(
                title: "Penggunaan Aplikasi",
                description:
                    "Aplikasi ini ditujukan untuk membantu orang tua memantau tumbuh kembang anak. Informasi yang disediakan bersifat edukatif dan tidak menggantikan saran medis profesional. Konsultasikan kondisi anak kepada tenaga kesehatan untuk diagnosis dan penanganan yang tepat.",
              ),
              SizedBox(height: 16.h),

              // Item 3
              _buildTermsCard(
                title: "Akun Pengguna",
                description:
                    "Anda bertanggung jawab menjaga kerahasiaan informasi akun Anda. Segala aktivitas yang terjadi melalui akun Anda sepenuhnya menjadi tanggung jawab Anda. Harap segera hubungi kami jika mendeteksi penggunaan akun yang tidak sah.",
              ),
              SizedBox(height: 16.h),

              // Item 4
              _buildTermsCard(
                title: "Data Pribadi & Privasi",
                description:
                    "Kami mengumpulkan data yang diperlukan untuk menjalankan layanan, termasuk informasi profil anak dan hasil asesmen. Data Anda digunakan semata-mata untuk memberikan layanan terbaik dan tidak akan dijual kepada pihak ketiga tanpa persetujuan Anda.",
              ),
              SizedBox(height: 28.h),

              Text(
                "Dengan menggunakan aplikasi, Anda menyetujui\nseluruh ketentuan di atas.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
