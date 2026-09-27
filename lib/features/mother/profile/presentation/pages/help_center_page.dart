import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const HeaderBasic(
        title: 'Pusat Bantuan',
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "Cari Pertanyaan",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Banner Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF0C9C48,
                  ), // Close match to screenshot green
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Butuh bantuan lebih?",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Tim kami siap membantu Anda",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0C9C48),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        "Hubungi",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              Text(
                "AKUN",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              _buildFaqGroup([
                {
                  'q': "Bagaimana cara mendaftarkan akun?",
                  'a':
                      "Unduh aplikasi, ketuk 'Daftar', masukkan email dan kata sandi, lalu verifikasi email Anda. Setelah itu, lengkapi profil anak untuk memulai.",
                },
                {
                  'q': "Lupa kata sandi, bagaimana cara mengatasinya?",
                  'a':
                      "Di halaman masuk, ketuk 'Lupa Kata Sandi', masukkan email terdaftar, dan ikuti tautan yang dikirim ke email Anda untuk membuat kata sandi baru.",
                },
                {
                  'q': "Bagaimana cara mengubah data profil?",
                  'a':
                      "Buka menu Profil \u2192 Ubah Profil, lalu edit informasi yang ingin diubah dan simpan perubahan.",
                },
              ]),

              SizedBox(height: 24.h),

              Text(
                "ASESMEN & KPSP",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              _buildFaqGroup([
                {
                  'q': "Apa itu KPSP?",
                  'a':
                      "KPSP (Kuesioner Pra Skrining Perkembangan) adalah alat skrining untuk mendeteksi dini kemungkinan penyimpangan perkembangan anak usia 0-72 bulan.",
                },
                {
                  'q': "Seberapa sering saya perlu melakukan asesmen?",
                  'a':
                      "Disarankan mengikuti jadwal asesmen sesuai usia anak. Notifikasi pengingat akan dikirimkan secara otomatis saat jadwal asesmen tiba.",
                },
                {
                  'q': "Apakah hasil asesmen bisa dicetak?",
                  'a':
                      "Ya, buka riwayat asesmen, pilih hasil yang ingin dicetak, lalu ketuk ikon berbagi atau cetak di pojok kanan atas.",
                },
              ]),

              SizedBox(height: 24.h),

              Text(
                "TEKNIS",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              _buildFaqGroup([
                {
                  'q': "Aplikasi tidak bisa dibuka, apa yang harus dilakukan?",
                  'a':
                      "Coba tutup dan buka kembali aplikasi. Pastikan koneksi internet stabil. Jika masih bermasalah, perbarui aplikasi ke versi terbaru.",
                },
                {
                  'q': "Bagaimana cara menghapus akun saya?",
                  'a':
                      "Buka Pengaturan \u2192 Hapus Akun. Penghapusan bersifat permanen dan tidak dapat dipulihkan. Semua data akan terhapus setelah 30 hari.",
                },
              ]),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqGroup(List<Map<String, String>> faqData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
      ),
      child: Column(
        children: faqData.asMap().entries.map((entry) {
          int idx = entry.key;
          String question = entry.value['q']!;
          String answer = entry.value['a']!;
          return Column(
            children: [
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: Colors.black87,
                  collapsedIconColor: Colors.black87,
                  title: Text(
                    question,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  childrenPadding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.h,
                  ),
                  children: [
                    Text(
                      answer,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.sp,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (idx < faqData.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFFF3F4F6),
                  indent: 16.w,
                  endIndent: 16.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
