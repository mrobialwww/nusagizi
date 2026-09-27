import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_cubit.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_state.dart';
import 'package:nusagizi/features/mother/home/presentation/widgets/flip_child_card.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_state.dart';
import 'package:nusagizi/core/widgets/loading_ellipsis_text.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class HomeMotherPage extends StatefulWidget {
  const HomeMotherPage({super.key});

  @override
  State<HomeMotherPage> createState() => _HomeMotherPageState();
}

class _HomeMotherPageState extends State<HomeMotherPage> {
  late final GoRouterDelegate _routerDelegate;
  late final AppLifecycleListener _lifecycleListener;
  bool _wasPaused = false;

  // Register lifecycle, navigation, and routing observers
  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onPause: () => _wasPaused = true,
      onResume: () {
        if (_wasPaused && motherNavTabNotifier.value == 0) _refetch();
        _wasPaused = false;
      },
    );
    motherNavTabNotifier.addListener(_onTabChanged);

    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);
  }

  // Re-fetch data automatically when returning (popping) to this page via routing
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final String location = _routerDelegate.currentConfiguration.uri
          .toString();
      // Hanya refetch jika router BENAR-BENAR pindah kembali ke home-mother.
      if (location == '/home-mother' && motherNavTabNotifier.value == 0) {
        final matches = _routerDelegate.currentConfiguration.matches;
        // Hanya refetch jika tidak ada halaman lain yang sedang di-push di atas home
        if (matches.length > 1 &&
            matches.last.matchedLocation != '/home-mother') {
          return;
        }

        _refetch();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    motherNavTabNotifier.removeListener(_onTabChanged);
    _routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  // Re-fetch data automatically when the user switches back to this tab
  void _onTabChanged() {
    // Index 0 adalah HomeMotherPage
    if (motherNavTabNotifier.value == 0) {
      _refetch();
    }
  }

  // Core function to trigger data reloading for children summary and profile
  void _refetch() {
    if (!mounted) return;
    context.read<MotherHomeCubit>().getChildrenSummary();
    context.read<UserProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MotherHomeCubit, MotherHomeState>(
      listener: (context, state) {
        if (state is MotherHomeLoaded && state.children.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            // Gunakan goNamed agar route berpindah sepenuhnya dan mencegah _onRouteChanged me-refetch tanpa henti
            context.goNamed(
              AppRoutes.editChildProfile.name,
              extra: {'fromHome': true},
            );
          });
        }
      },
      builder: (context, state) {
        if (state is MotherHomeLoaded && state.children.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox.shrink(),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFEAF7EE),
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle:
                SystemUiOverlayStyle.dark, // Ensures status bar icons are dark
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section (Header)
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<UserProfileCubit, UserProfileState>(
                        builder: (context, state) {
                          String title = 'Bunda';
                          String firstName = '';
                          String? photoUrl;

                          if (state is UserProfileLoaded) {
                            if (state.profile.gender == 'male') {
                              title = 'Ayah';
                            }

                            final fullName = state.profile.fullName;
                            if (fullName.isNotEmpty) {
                              firstName = fullName.split(' ').first;
                            }
                            photoUrl = state.profile.photoUrl;
                          }

                          return Row(
                            children: [
                              (state is UserProfileLoading ||
                                      state is UserProfileInitial)
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
                                          ImageHelper.getSafeImageProvider(
                                            photoUrl,
                                          ) ??
                                          ImageHelper.getDefaultUserImage(
                                            state is UserProfileLoaded
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
                                      color: Colors.grey[600],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  (state is UserProfileLoading ||
                                          state is UserProfileInitial)
                                      ? LoadingEllipsisText(
                                          text: '',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                          ),
                                        )
                                      : Text(
                                          '$title${firstName.isNotEmpty ? ' $firstName' : ''} 👋',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.notification.name);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20.r,
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                                size: 24.sp,
                              ),
                            ),
                            Positioned(
                              right: 8.w,
                              top: 8.h,
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
                  ),
                ),

                // Welcome Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apa kabar si kecil',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'hari ini?',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00A735),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Carousel Slider
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is MotherHomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A735),
                          ),
                        );
                      } else if (state is MotherHomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48.sp,
                                color: Colors.red.shade300,
                              ),
                              SizedBox(height: 16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red.shade400,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context
                                      .read<MotherHomeCubit>()
                                      .getChildrenSummary();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  size: 18.sp,
                                  color: const Color(0xFF00A735),
                                ),
                                label: Text(
                                  "Coba Lagi",
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    color: const Color(0xFF00A735),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF00A735),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is MotherHomeLoaded) {
                        if (state.children.isEmpty) {
                          return Center(
                            child: Text(
                              'Belum ada data anak.',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return CarouselSlider.builder(
                          options: CarouselOptions(
                            height: double.infinity,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            viewportFraction: 0.8,
                            clipBehavior: Clip.none,
                          ),
                          itemCount: state.children.length,
                          itemBuilder: (context, index, realIndex) {
                            final childData = state.children[index];
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                              child: FlipChildCard(
                                key: ValueKey('flip-${childData.id}'),
                                childData: childData,
                              ),
                            );
                          },
                        );
                      }

                      // Initial state or fallback
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
