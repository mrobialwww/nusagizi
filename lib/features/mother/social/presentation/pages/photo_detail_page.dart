import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/photo_detail_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/gallery_filter_dialog.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/share_bottom_sheet.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/retake_photo_cubit.dart';

class PhotoDetailPage extends StatefulWidget {
  final String? photoId;
  final String imageUrl;
  final VoidCallback? closeBottomSheet;

  const PhotoDetailPage({
    super.key,
    this.photoId,
    required this.imageUrl,
    this.closeBottomSheet,
  });

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.photoId != null) {
      context.read<PhotoDetailCubit>().fetchDetail(widget.photoId!);
    }
  }

  // Using overlay for dropdown to exactly mimic the image
  void _showFriendsDropdown() async {
    GalleryCubit? galleryCubit;
    try {
      galleryCubit = context.read<GalleryCubit>();
    } catch (_) {}

    if (galleryCubit == null) return;

    final selectedTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: galleryCubit!),
          BlocProvider(create: (_) => sl<ContactsCubit>()..fetchContacts()),
        ],
        child: const GalleryFilterDialog(),
      ),
    );

    if (selectedTitle != null && selectedTitle.isNotEmpty) {
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar with Anda dropdown
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: GestureDetector(
                onTap: _showFriendsDropdown,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Anda',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Image Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(36.r),
                          child:
                              ImageHelper.getSafeImageProvider(
                                    widget.imageUrl,
                                  ) !=
                                  null
                              ? Image(
                                  image: ImageHelper.getSafeImageProvider(
                                    widget.imageUrl,
                                  )!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,

                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          height: 300.h,
                                          width: double.infinity,
                                          color: Colors.grey[900],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                  // error fallback
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 300.h,
                                      width: double.infinity,
                                      color: Colors.grey[900],
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 48.sp,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 300.h,
                                  width: double.infinity,
                                  color: Colors.grey[900],
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 48.sp,
                                    ),
                                  ),
                                ),
                        ),
                        BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
                          builder: (context, state) {
                            if (state is PhotoDetailLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is PhotoDetailLoaded &&
                                state.photo.caption != null &&
                                state.photo.caption!.isNotEmpty) {
                              return Positioned(
                                bottom: 20.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF5A5A5A,
                                    ).withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    state.photo.caption!,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // User Info
            SizedBox(
              height: 24.r,
              child: BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
                builder: (context, state) {
                  if (state is PhotoDetailLoaded) {
                    final children = sl<ChildrenCacheCubit>().state;

                    ChildHeaderEntity? matchedChild;
                    try {
                      for (var c in children) {
                        if (c.id == state.photo.childId) {
                          matchedChild = c;
                          break;
                        }
                      }
                    } catch (_) {}

                    final avatarProvider =
                        ImageHelper.getSafeImageProvider(
                          matchedChild?.imagePath,
                        ) ??
                        ImageHelper.getDefaultChildImage(
                          matchedChild?.gender ?? 'Male',
                        );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 12.r,
                          backgroundImage: avatarProvider,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          matchedChild?.name ?? 'Anak Anda',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            SizedBox(height: 40.h),

            // Bottom Actions
            Padding(
              padding: EdgeInsets.only(
                bottom: 80 + MediaQuery.paddingOf(context).bottom,
              ),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.grid_view,
                            color: Colors.white70,
                            size: 30.w,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        GestureDetector(
                          onTap: () {
                            // Hancurkan/hapus GalleryBottomSheet di balik layar tanpa animasi
                            // agar tidak menyebabkan error navigasi ganda yang tumpang tindih.
                            widget.closeBottomSheet?.call();

                            if (context.mounted) {
                              context.pop();
                            }
                          },
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
                        SizedBox(width: 20.w),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => BlocProvider(
                                create: (_) => sl<RetakePhotoCubit>(),
                                child: ShareBottomSheet(
                                  imageUrl: widget.imageUrl,
                                  onRetakeMode: () {
                                    context.pop(); // Tutup ShareBottomSheet
                                    if (widget.closeBottomSheet != null) {
                                      widget
                                          .closeBottomSheet!(); // Tutup GalleryBottomSheet
                                    }
                                    context.goNamed(
                                      AppRoutes.socialMother.name,
                                      queryParameters: {
                                        'retakeUrl': widget.imageUrl,
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.file_download_outlined,
                            color: Colors.white70,
                            size: 30.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
