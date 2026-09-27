import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_state.dart';
import 'package:nusagizi/core/widgets/loading_ellipsis_text.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class CaregiverHomeHeader extends StatelessWidget {
  const CaregiverHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<CaregiverProfileCubit, CaregiverProfileState>(
          builder: (context, state) {
            String firstName = 'Pengasuh';
            String? photoUrl;

            if (state is CaregiverProfileLoaded) {
              final fullName = state.profile.fullName;
              if (fullName.isNotEmpty) {
                firstName = fullName.split(' ').first;
              }
              photoUrl = state.profile.photoUrl;
            }

            return Row(
              children: [
                (state is CaregiverProfileLoading ||
                        state is CaregiverProfileInitial)
                    ? Container(
                        width: 40.r,
                        height: 40.r,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                      )
                    : CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            ImageHelper.getSafeImageProvider(photoUrl) ??
                            ImageHelper.getDefaultUserImage(
                              state is CaregiverProfileLoaded
                                  ? state.profile.gender
                                  : null,
                            ),
                      ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo,',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 13.sp,
                      ),
                    ),
                    (state is CaregiverProfileLoading ||
                            state is CaregiverProfileInitial)
                        ? LoadingEllipsisText(
                            text: '',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          )
                        : Text(
                            'Pengasuh $firstName 👋',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                  ],
                ),
              ],
            );
          },
        ),
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.caregiverNotification.name),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.r,
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                  size: 24.sp,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
