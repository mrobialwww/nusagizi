import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';

class GalleryFilterDialog extends StatelessWidget {
  const GalleryFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 80.h, left: 60.w, right: 60.w),
      backgroundColor: const Color(0xFF424242),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(context, Icons.people, null, 'Semua orang', null),
            _buildMenuItem(context, null, AppImages.childHome1, 'Anda', null),
            BlocBuilder<ContactsCubit, ContactsState>(
              builder: (context, state) {
                if (state is ContactsLoading) {
                  return Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ContactsLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: state.contacts.map((contact) {
                      return _buildMenuItem(
                        context,
                        null,
                        contact.photoUrl,
                        contact.fullName,
                        contact.contactId,
                      );
                    }).toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData? icon,
    String? imageUrl,
    String title,
    String? contactId,
  ) {
    return InkWell(
      onTap: () {
        if (contactId == null && title == 'Semua orang') {
          context.read<GalleryCubit>().fetchAllPhotos();
        } else if (contactId == null && title == 'Anda') {
          context.read<GalleryCubit>().fetchOwnPhotos();
        } else if (contactId != null) {
          context.read<GalleryCubit>().fetchContactPhotos(contactId, title);
        }
        Navigator.pop(context, title);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            if (icon != null)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 16.sp),
              )
            else if (imageUrl != null)
              CircleAvatar(
                radius: 12.r,
                backgroundImage:
                    ImageHelper.getSafeImageProvider(imageUrl) ??
                    const AssetImage(AppImages.childHome1),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white54, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
