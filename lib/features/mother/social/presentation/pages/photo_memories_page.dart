import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/gallery_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/memory_month_card.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';

class PhotoMemoriesPage extends StatelessWidget {
  final String? childId;
  const PhotoMemoriesPage({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GalleryCubit>()..fetchOwnPhotos(childId),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Top Header
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Text(
                      'Memori',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Memories List
                  Expanded(
                    child: BlocBuilder<GalleryCubit, GalleryState>(
                      builder: (context, state) {
                        if (state is GalleryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GalleryError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state is GalleryLoaded) {
                          if (state.photos.isEmpty) {
                            return Center(
                              child: Text(
                                'Belum ada memori.',
                                style: GoogleFonts.outfit(color: Colors.grey),
                              ),
                            );
                          }

                          // Group photos by Month Year (Normalize to first day of month)
                          final Map<DateTime, List<ChildPhotoEntity>>
                          groupedMemories = {};
                          for (var photo in state.photos) {
                            final date =
                                photo.createdAt?.toLocal() ?? DateTime.now();
                            final monthDate = DateTime(
                              date.year,
                              date.month,
                              1,
                            );

                            if (!groupedMemories.containsKey(monthDate)) {
                              groupedMemories[monthDate] = [];
                            }
                            groupedMemories[monthDate]!.add(photo);
                          }

                          // Sort newest months first
                          final keys = groupedMemories.keys.toList()
                            ..sort((a, b) => b.compareTo(a));

                          return ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: 120.h,
                              left: 20.w,
                              right: 20.w,
                            ),
                            itemCount: keys.length,
                            itemBuilder: (context, index) {
                              final monthDate = keys[index];
                              final photos = groupedMemories[monthDate]!;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: MemoryMonthCard(
                                  monthDate: monthDate,
                                  photos: photos,
                                ),
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

              // Bottom Gradient and Back Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 140,
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
                    child: GestureDetector(
                      onTap: () => context.pop(), // Acts like a back button
                      child: Container(
                        width: 60,
                        height: 60,
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
            ],
          ),
        ),
      ),
    );
  }
}
