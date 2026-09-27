import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/review_photos_cubit.dart';

class ReviewPhotosPage extends StatelessWidget {
  const ReviewPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewPhotosCubit>()..fetchPendingReviewPhotos(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Tinjau Foto',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ReviewPhotosCubit, ReviewPhotosState>(
          builder: (context, state) {
            if (state is ReviewPhotosLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewPhotosError) {
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
            } else if (state is ReviewPhotosLoaded) {
              final photos = state.photos;
              if (photos.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada foto yang perlu ditinjau.',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final imageUrl = photo.photoUrl;

                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.reviewChildPhoto.name,
                        extra: {
                          'photoId': photo.id,
                          'image': imageUrl,
                          'childId': photo.childId,
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: ImageHelper.getSafeImageProvider(imageUrl) != null
                          ? Image(
                              image: ImageHelper.getSafeImageProvider(
                                imageUrl,
                              )!,
                              fit: BoxFit.cover,
                            )
                          : Container(color: Colors.grey[800]),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
