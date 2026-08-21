import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';

class SocialFriendsBottomSheet extends StatelessWidget {
  const SocialFriendsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactsCubit>()..fetchContacts(),
      child: const _SocialFriendsBottomSheetContent(),
    );
  }
}

class _SocialFriendsBottomSheetContent extends StatelessWidget {
  const _SocialFriendsBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactsCubit, ContactsState>(
      listenWhen: (previous, current) =>
          current is ContactsDeleteSuccess || current is ContactsDeleteError,
      listener: (context, state) {
        if (state is ContactsDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kontak berhasil dihapus')),
          );
        } else if (state is ContactsDeleteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark background matching image
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Center(
              child: BlocBuilder<ContactsCubit, ContactsState>(
                buildWhen: (previous, current) =>
                    current is ContactsLoaded ||
                    current is ContactsLoading ||
                    current is ContactsError,
                builder: (context, state) {
                  int count = 0;
                  if (state is ContactsLoaded) {
                    count = state.contacts.length;
                  }
                  return Text(
                    '$count Teman',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),

            // Share Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Icon(Icons.ios_share, color: Colors.white70, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Bagikan Akun Anda',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Share Options Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShareOption(
                      const Color(0xFF25D366),
                      Icons.phone,
                      'WhatsApp',
                    ),
                    _buildShareOption(
                      Colors.transparent,
                      Icons.camera_alt,
                      'Instagram',
                      isInstagram: true,
                    ),
                    _buildShareOption(
                      const Color(0xFF25D366),
                      Icons.chat_bubble,
                      'SMS',
                    ),
                    _buildShareOption(
                      Colors.grey.shade600,
                      Icons.link,
                      'Lainnya',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // Friends Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.white70, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Teman Anda',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Friends List
            Expanded(
              child: BlocBuilder<ContactsCubit, ContactsState>(
                buildWhen: (previous, current) =>
                    current is ContactsLoaded ||
                    current is ContactsLoading ||
                    current is ContactsError,
                builder: (context, state) {
                  if (state is ContactsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContactsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is ContactsLoaded) {
                    if (state.contacts.isEmpty) {
                      return Center(
                        child: Text(
                          'Mulai ikuti teman!',
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        return BlocSelector<ContactsCubit, ContactsState, bool>(
                          selector: (state) =>
                              state is ContactsDeleteLoading &&
                              state.contactId == contact.contactId,
                          builder: (context, isDeleting) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  // Avatar with green border
                                  Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF00A735),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: contact.photoUrl != null
                                          ? ImageHelper.getSafeImageProvider(
                                              contact.photoUrl!,
                                            )
                                          : const AssetImage(
                                              AppImages.childHome1,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      contact.fullName,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isDeleting)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    IconButton(
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Hapus Teman'),
                                              content: Text(
                                                'Apakah Anda yakin ingin menghapus ${contact.fullName} dari daftar teman?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true &&
                                            context.mounted) {
                                          context
                                              .read<ContactsCubit>()
                                              .deleteContact(contact.contactId);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white70,
                                        size: 20.sp,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    Color color,
    IconData icon,
    String label, {
    bool isInstagram = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isInstagram ? null : color,
            gradient: isInstagram
                ? const LinearGradient(
                    colors: [
                      Color(0xFF833AB4),
                      Color(0xFFFD1D1D),
                      Color(0xFFF56040),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )
                : null,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp),
        ),
      ],
    );
  }
}
