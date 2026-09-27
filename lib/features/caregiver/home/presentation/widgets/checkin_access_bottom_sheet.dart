import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';

class CheckinAccessBottomSheet extends StatefulWidget {
  final ChildPreviewEntity data;
  final Future<bool?> Function() onAccept;

  const CheckinAccessBottomSheet({
    super.key,
    required this.data,
    required this.onAccept,
  });

  @override
  State<CheckinAccessBottomSheet> createState() =>
      _CheckinAccessBottomSheetState();
}

class _CheckinAccessBottomSheetState extends State<CheckinAccessBottomSheet> {
  bool _isLoading = false;
  bool? _isSuccess;

  Future<void> _handleAccept() async {
    setState(() => _isLoading = true);

    final result = await widget.onAccept();

    if (!mounted) return;

    if (result == null) {
      context.pop();
      return;
    }

    setState(() {
      _isLoading = false;
      _isSuccess = result;
    });
  }

  void _close() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 12.h,
        left: 24.w,
        right: 24.w,
        bottom: 12.h,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: _isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: const CircularProgressIndicator(
                            color: Color(0xFF00A735),
                          ),
                        )
                      : _isSuccess == true
                      ? _buildResultContent(
                          icon: Icons.check,
                          iconColor: const Color(0xFF00A735),
                          iconBgColor: const Color(0xFFE8F5E9),
                          title: 'Berhasil Terhubung 🎉',
                          titleColor: const Color(0xFF00A735),
                          description:
                              'Anda telah terhubung dan dapat mengakses\ninformasi sesuai izin yang diberikan oleh orang tua.',
                          buttonText: 'Lihat Menu Hari Ini',
                          isPrimaryButton: true,
                        )
                      : _isSuccess == false
                      ? _buildResultContent(
                          icon: Icons.close,
                          iconColor: const Color(0xFFD32F2F),
                          iconBgColor: const Color(0xFFFFEBEE),
                          title: 'Belum Bisa Terhubung',
                          titleColor: const Color(0xFFD32F2F),
                          description:
                              'Profil anak sudah terhubung dengan pengasuh lain.\nMinta ibu melepas akses pengasuh sebelumnya\nuntuk melanjutkan.',
                          buttonText: 'Mengerti',
                          isPrimaryButton: false,
                        )
                      : _buildConfirmContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 80.r,
          height: 80.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE8F5E9), width: 6.r),
            image:
                (widget.data.photoUrl != null &&
                    widget.data.photoUrl!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(widget.data.photoUrl!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage(AppImages.defaultMaleChildProfile),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Konfirmasi Akses',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Anda akan terhubung dengan profil berikut.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F4),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nama',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    widget.data.fullName,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Usia',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    widget.data.ageText,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Orang Tua',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    widget.data.motherName,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _close,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: const BorderSide(color: Color(0xFF00A735), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: const Color(0xFF00A735),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleAccept,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  backgroundColor: const Color(0xFF00A735),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Terima Akses',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultContent({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required Color titleColor,
    required String description,
    required String buttonText,
    required bool isPrimaryButton,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 64.sp),
        ),
        SizedBox(height: 24.h),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 32.h),
        SizedBox(
          width: double.infinity,
          child: isPrimaryButton
              ? ElevatedButton(
                  onPressed: () {
                    context.pop();
                    context.goNamed(AppRoutes.homeCaregiver.name);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: const Color(0xFF00A735),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () {
                    context.pop();
                    context.goNamed(AppRoutes.homeCaregiver.name);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: const BorderSide(color: Color(0xFF00A735)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: const Color(0xFF00A735),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
