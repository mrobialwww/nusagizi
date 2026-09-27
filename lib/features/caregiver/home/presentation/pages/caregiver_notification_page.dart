import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/home/domain/entities/notification_entity.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_notification_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_notification_state.dart';

class CaregiverNotificationPage extends StatefulWidget {
  const CaregiverNotificationPage({super.key});

  @override
  State<CaregiverNotificationPage> createState() =>
      _CaregiverNotificationPageState();
}

class _CaregiverNotificationPageState extends State<CaregiverNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CaregiverNotificationCubit>()..getAllNotifications(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FDF9),
        appBar: const HeaderBasic(
          backgroundColor: Colors.white,
          title: 'Notifikasi',
        ),
        body:
            BlocBuilder<CaregiverNotificationCubit, CaregiverNotificationState>(
              builder: (context, state) {
                if (state is CaregiverNotificationLoading ||
                    state is CaregiverNotificationInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A735)),
                  );
                } else if (state is CaregiverNotificationError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                } else if (state is CaregiverNotificationLoaded) {
                  final notifications = state.notifications;
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppVectors.emptyNotification,
                            height: 175.h,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Belum Ada Notifikasi',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: const Color(0xFFEEEEEE), height: 32.h),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _buildNotificationItem(notif);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationEntity notif) {
    // Basic date formatting
    String displayTime = notif.createdAt;
    try {
      final dateTime = DateTime.parse(notif.createdAt).toLocal();
      displayTime =
          "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (_) {}

    // Determine icon based on type mimicking original mock data
    IconData iconData = Icons.notifications;
    bool isOutline = false;
    if (notif.notificationType.contains("meal") ||
        notif.title.toLowerCase().contains("makan")) {
      iconData = Icons.wb_sunny;
      isOutline = true;
    } else if (notif.notificationType.contains("upload") ||
        notif.title.toLowerCase().contains("foto")) {
      iconData = Icons.camera_alt;
      isOutline = false;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isOutline ? Colors.transparent : const Color(0xFF00A735),
            border: isOutline
                ? Border.all(color: const Color(0xFF00A735), width: 2)
                : null,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            iconData,
            color: isOutline ? const Color(0xFF00A735) : Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notif.title,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black87,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                notif.message.isNotEmpty ? notif.message : displayTime,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
