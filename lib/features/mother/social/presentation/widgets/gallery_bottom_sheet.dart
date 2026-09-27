import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/router.dart';

import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/gallery_filter_dialog.dart';

class GalleryBottomSheet extends StatefulWidget {
  const GalleryBottomSheet({super.key});

  @override
  State<GalleryBottomSheet> createState() => _GalleryBottomSheetState();
}

class _GalleryBottomSheetState extends State<GalleryBottomSheet> {
  String currentFilterTitle = 'Semua Orang';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<GalleryCubit>()..fetchAllPhotos()),
        BlocProvider(create: (_) => sl<ContactsCubit>()..fetchContacts()),
      ],
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildFilterChip(context),
                    SizedBox(height: 20.h),
                    _buildGalleryContent(),
                  ],
                ),
                _buildCloseButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final galleryCubit = context.read<GalleryCubit>();
        final contactsCubit = context.read<ContactsCubit>();
        final selectedTitle = await showDialog<String>(
          context: context,
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: galleryCubit),
              BlocProvider.value(value: contactsCubit),
            ],
            child: const GalleryFilterDialog(),
          ),
        );

        if (selectedTitle != null && selectedTitle.isNotEmpty) {
          setState(() {
            currentFilterTitle = selectedTitle;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentFilterTitle,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryContent() {
    return Expanded(
      child: BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GalleryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is GalleryLoaded) {
            return _buildGrid(context, state.photos);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<ChildPhotoEntity> photos) {
    final reviewPhotos = photos.where((p) => p.isReviewRequired).toList();
    final hasReviewGateway = reviewPhotos.isNotEmpty;

    final gridPhotos = photos.where((p) => !p.isReviewRequired).toList();

    if (gridPhotos.isEmpty && !hasReviewGateway) {
      return Center(
        child: Text(
          'Belum ada foto',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w500,
            color: Colors.white54,
          ),
        ),
      );
    }

    final totalGridItems = gridPhotos.length + (hasReviewGateway ? 1 : 0);

    return GridView.builder(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 120.h),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0, // Square items
      ),
      itemCount: totalGridItems,
      itemBuilder: (context, index) {
        if (hasReviewGateway && index == 0) {
          return _buildReviewGateway(context, reviewPhotos);
        }

        final photoIndex = hasReviewGateway ? index - 1 : index;
        return _buildPhotoItem(context, gridPhotos[photoIndex]);
      },
    );
  }

  Widget _buildReviewGateway(
    BuildContext context,
    List<ChildPhotoEntity> reviewPhotos,
  ) {
    final firstReviewUrl = reviewPhotos.first.photoUrl;
    final imageProvider = ImageHelper.getSafeImageProvider(firstReviewUrl);

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.reviewPhotos.name);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageProvider != null
                ? Image(image: imageProvider, fit: BoxFit.cover)
                : Container(color: Colors.grey[800]),
            Container(color: Colors.black.withValues(alpha: 0.5)),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library, color: Colors.white, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Tinjau Foto: ${reviewPhotos.length}',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, ChildPhotoEntity photo) {
    final imageProvider = ImageHelper.getSafeImageProvider(photo.photoUrl);

    return GestureDetector(
      onTap: () {
        final route = ModalRoute.of(context);
        final nav = Navigator.of(context);

        context.pushNamed(
          AppRoutes.photoDetail.name,
          extra: {
            'photoId': photo.id,
            'image': photo.photoUrl,
            'galleryCubit': context.read<GalleryCubit>(),
            'closeBottomSheet': () {
              if (route != null && route.isActive) {
                nav.removeRoute(route);
              }
            },
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: imageProvider != null
            ? Image(
                image: imageProvider,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
                ),
              ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A1A).withValues(alpha: 0.0),
              const Color(0xFF1A1A1A).withValues(alpha: 0.8),
              const Color(0xFF1A1A1A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: EdgeInsets.all(4.w),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
