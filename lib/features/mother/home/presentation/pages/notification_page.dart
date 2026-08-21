import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/domain/entities/notification_entity.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/notification_cubit.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/notification_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>()..getAllNotifications(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FDF9),
        appBar: const HeaderBasic(
          backgroundColor: Color(0xFFF9FDF9),
          title: 'Notifikasi',
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading || state is NotificationInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              );
            } else if (state is NotificationError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppVectors.emptyNotification,
                        height: 180,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Belum ada notifikasi',
                        style: GoogleFonts.outfit(
                          color: Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Color(0xFFEEEEEE), height: 32),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.notifications, color: const Color(0xFF00A735), size: 24.sp),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notif.title,
                      style: GoogleFonts.outfit(
                        color: Colors.black87,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    displayTime,
                    style: GoogleFonts.outfit(
                      color: Colors.black38,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                notif.message,
                style: GoogleFonts.outfit(
                  color: Colors.black54,
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
