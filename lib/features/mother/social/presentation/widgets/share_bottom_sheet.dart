import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:nusagizi/router.dart';

class ShareBottomSheet extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onRetakeMode;

  const ShareBottomSheet({
    super.key,
    required this.imageUrl,
    this.onRetakeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 24.h + MediaQuery.paddingOf(context).bottom,
        top: 16.h,
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 32.h),
          _buildSocialOptions(),
          SizedBox(height: 32.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24), // For balancing the centering
        Expanded(
          child: Center(
            child: Text(
              'Bagikan',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.close, color: Colors.white, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildSocialOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSocialItem(
          icon: Icons.chat, // closest default to WA
          label: 'WhatsApp',
          circleColor: const Color(0xFF25D366),
        ),
        _buildSocialItem(
          icon: Icons.camera_alt, // closest default to IG
          label: 'Instagram',
          isGradient: true,
        ),
        _buildSocialItem(
          icon: Icons.chat_bubble, // For SMS
          label: 'SMS',
          circleColor: const Color(0xFF13C752),
        ),
        _buildSocialItem(
          icon: Icons.link, // For Lainnya
          label: 'Lainnya',
          circleColor: const Color(0xFF535353), // standard gray
        ),
      ],
    );
  }

  Widget _buildSocialItem({
    required IconData icon,
    required String label,
    Color? circleColor,
    bool isGradient = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isGradient ? null : circleColor,
            gradient: isGradient
                ? const LinearGradient(
                    colors: [
                      Color(0xFF833AB4),
                      Color(0xFFFD1D1D),
                      Color(0xFFF56040),
                      Color(0xFFFCAF45),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )
                : null,
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 28.sp),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            icon: Icons.file_download_outlined,
            label: 'Simpan',
            onTap: () {},
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildButton(
            icon: Icons.camera_alt,
            label: 'Foto Ulang',
            onTap: () {
              if (onRetakeMode != null) {
                onRetakeMode!();
              } else {
                context.goNamed(
                  AppRoutes.socialMother.name,
                  queryParameters: {'retakeUrl': imageUrl},
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF424242),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
