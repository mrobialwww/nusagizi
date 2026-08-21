import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_state.dart';

class ChildProfilePage extends StatefulWidget {
  const ChildProfilePage({super.key});

  @override
  State<ChildProfilePage> createState() => _ChildProfilePageState();
}

class _ChildProfilePageState extends State<ChildProfilePage> {
  late final GoRouterDelegate _routerDelegate;

  @override
  void initState() {
    super.initState();
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  // Refetch daftar anak hanya jika ada CRUD yang terjadi di child page.
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final location = _routerDelegate.currentConfiguration.uri.toString();
      if (location == '/profile-mother/child-profile') {
        if (crudFlag) {
          context.read<ChildProfileCubit>().loadChildren();
          crudFlag = false;
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: const HeaderBasic(
        title: 'Profil Anak',
        backgroundColor: Color(0xFFF4F6F4),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ChildProfileCubit>().loadChildren();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20.0.w),
          child: BlocBuilder<ChildProfileCubit, ChildProfileState>(
            builder: (context, state) {
              if (state is ChildProfileLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A735)),
                  ),
                );
              } else if (state is ChildProfileError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                );
              } else if (state is ChildProfileLoaded) {
                if (state.children.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(
                      child: Text('Belum ada profil anak terdaftar.'),
                    ),
                  );
                }
                return Column(
                  children: [
                    ...state.children.asMap().entries.map((entry) {
                      final child = entry.value;
                      final imageAsset = AppImages.childHome1;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: GestureDetector(
                          onTap: () => context.goNamed(
                            AppRoutes.editChildProfile.name,
                            extra: child,
                          ),
                          child: _buildChildCard(
                            name: child.fullName,
                            age: child.age,
                            imageAsset: child.photoUrl ?? imageAsset,
                            isNetworkImage: child.photoUrl != null,
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => context.goNamed(AppRoutes.editChildProfile.name),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A735),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Tambah Profil Anak',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard({
    required String name,
    required String age,
    required String imageAsset,
    bool isNetworkImage = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: isNetworkImage
                ? NetworkImage(imageAsset)
                : AssetImage(imageAsset) as ImageProvider,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  age,
                  style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chevron_right, color: Colors.grey, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
