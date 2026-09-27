import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/invite_access_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/invite_access_state.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/child_dropdown.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

class InviteAccessBottomSheet extends StatefulWidget {
  final String childId;
  const InviteAccessBottomSheet({super.key, required this.childId});

  @override
  State<InviteAccessBottomSheet> createState() =>
      _InviteAccessBottomSheetState();
}

class _InviteAccessBottomSheetState extends State<InviteAccessBottomSheet> {
  DateTime? _expiresAt;
  Duration _remaining = Duration.zero;
  Timer? _countdownTimer;
  late String _selectedChildId;

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.childId;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown({required VoidCallback onExpired}) {
    _countdownTimer?.cancel();
    _updateRemaining(onExpired: onExpired);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining(onExpired: onExpired);
    });
  }

  void _updateRemaining({required VoidCallback onExpired}) {
    if (_expiresAt == null) return;
    final diff = _expiresAt!.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);

    if (diff.isNegative) {
      _countdownTimer?.cancel();
      onExpired();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _buildQrSection(BuildContext context, InviteAccessState state) {
    if (state is InviteAccessLoading || state is InviteAccessInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00A735)),
      );
    }

    if (state is InviteAccessError) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.red.shade100, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Gagal Memuat QR Code',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.red.shade700,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => context.read<InviteAccessCubit>().generateToken(
                _selectedChildId,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              icon: Icon(Icons.refresh_rounded, size: 18.sp),
              label: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is InviteAccessSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12),
                ],
              ),
              child: QrImageView(
                data: jsonEncode({
                  "token": state.token,
                  "childId": _selectedChildId,
                }),
                size: 200.w,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Kode Berlaku ${_formatDuration(_remaining)}',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InviteAccessCubit>()..generateToken(widget.childId),
      child: BlocConsumer<InviteAccessCubit, InviteAccessState>(
        listener: (context, state) {
          if (state is InviteAccessSuccess) {
            setState(() => _expiresAt = state.expiresAt);
            _startCountdown(
              onExpired: () {
                context.read<InviteAccessCubit>().generateToken(
                  _selectedChildId,
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.only(
              top: 12.h,
              left: 20.w,
              right: 20.w,
              bottom: 20.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 32.h),

                // Child's Name Dropdown
                BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
                  builder: (context, children) {
                    return ChildDropdown(
                      initialChildId: _selectedChildId,
                      onChanged: (childId) {
                        setState(() => _selectedChildId = childId);
                        context.read<InviteAccessCubit>().generateToken(
                          childId,
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Grey QR Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F4),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'Undang Pengasuh',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.black87,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Bagikan QR ini kepada pengasuh agar dapat membantu menjalankan rutinitas harian anak.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.black54,
                          fontSize: 12.sp,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      _buildQrSection(context, state),

                      // Refresh QR Button
                      TextButton(
                        onPressed: () => context
                            .read<InviteAccessCubit>()
                            .generateToken(_selectedChildId),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Perbarui QR',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: const Color(0xFF00A735),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // Bottom Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00A735)),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Bagikan QR',
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
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00A735)),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Manajemen Akses',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: const Color(0xFF00A735),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
