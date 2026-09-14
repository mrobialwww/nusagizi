import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_home_cubit.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_home_state.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_children_cache_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_state.dart';
import 'package:nusagizi/features/caregiver/home/presentation/widgets/caregiver_child_selector.dart';
import 'package:nusagizi/features/caregiver/home/presentation/widgets/caregiver_home_header.dart';
import 'package:nusagizi/features/caregiver/home/presentation/widgets/caregiver_meal_card.dart';
import 'package:intl/intl.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/layout/caregiver_layout_scaffold.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';

class HomeCaregiverPage extends StatefulWidget {
  const HomeCaregiverPage({super.key});

  @override
  State<HomeCaregiverPage> createState() => _HomeCaregiverPageState();
}

class _HomeCaregiverPageState extends State<HomeCaregiverPage>
    with WidgetsBindingObserver {
  int _selectedChildIndex = 0;
  late final GoRouterDelegate _routerDelegate;

  // Register lifecycle, navigation, and routing observers
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    caregiverNavTabNotifier.addListener(_onTabChanged);

    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);

    context.read<CaregiverHomeCubit>().getChildrenSummary();

    final cache = context.read<CaregiverChildrenCacheCubit>().state;
    if (cache.isNotEmpty && _selectedChildIndex < cache.length) {
      context.read<CaregiverTodayMenuCubit>().fetchTodayMenu(
        cache[_selectedChildIndex].id,
      );
    }
  }

  // Re-fetch data automatically when returning (popping) to this page via routing
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final String location = _routerDelegate.currentConfiguration.uri
          .toString();
      if (location == '/home-caregiver' && caregiverNavTabNotifier.value == 0) {
        _refetch();
      }
    } catch (_) {}
  }

  // Clean up and remove all listeners to prevent memory leaks
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    caregiverNavTabNotifier.removeListener(_onTabChanged);
    _routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  // Re-fetch data automatically when the user switches back to this tab
  void _onTabChanged() {
    // Index 0 adalah HomeCaregiverPage
    if (caregiverNavTabNotifier.value == 0) {
      _refetch();
    }
  }

  // Re-fetch data automatically when the app is resumed from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        caregiverNavTabNotifier.value == 0) {
      _refetch();
    }
  }

  // Core function to trigger data reloading for children summary and profile
  void _refetch() {
    if (!mounted) return;
    context.read<CaregiverProfileCubit>().loadProfile();
    context.read<CaregiverHomeCubit>().getChildrenSummary();

    // Get children data from hydrated bloc
    final cache = context.read<CaregiverChildrenCacheCubit>().state;
    if (cache.isNotEmpty && _selectedChildIndex < cache.length) {
      context.read<CaregiverTodayMenuCubit>().fetchTodayMenu(
        cache[_selectedChildIndex].id,
      );
    }
  }

  void _onChildSelected(int index, List<ChildHeaderEntity> children) {
    if (index >= children.length) return;
    setState(() => _selectedChildIndex = index);

    final childId = children[index].id;
    context.read<CaregiverTodayMenuCubit>().fetchTodayMenu(childId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF7EE), Color(0xFFF7F7F7)],
          stops: [0.0, 0.4],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SafeArea(
          child: BlocBuilder<CaregiverChildrenCacheCubit, List<ChildHeaderEntity>>(
            builder: (context, children) {
              // Case: No child connected
              if (children.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      child: const CaregiverHomeHeader(),
                    ),
                    Expanded(child: _buildEmptyConnectionState(context)),
                  ],
                );
              }
              // Case: Child connected — check menu state
              return BlocBuilder<CaregiverHomeCubit, CaregiverHomeState>(
                builder: (context, homeState) {
                  return BlocBuilder<
                    CaregiverTodayMenuCubit,
                    CaregiverTodayMenuState
                  >(
                    builder: (context, menuState) {
                      final isLoading =
                          homeState is CaregiverHomeLoading ||
                          menuState is CaregiverTodayMenuLoading;
                      final homeError = homeState is CaregiverHomeError
                          ? homeState.message
                          : null;
                      final menuError = menuState is CaregiverTodayMenuError
                          ? menuState.message
                          : null;

                      // Resolve recipes early to branch before entering scroll
                      final List<RecipeEntity> recipes =
                          menuState is CaregiverTodayMenuLoaded
                          ? (menuState.data.menu?.recipes ?? [])
                          : [];

                      // Case: Normal scrollable content
                      final cache = context
                          .read<CaregiverChildrenCacheCubit>()
                          .state;
                      String childName = "Anak";
                      String childId = "";
                      if (cache.isNotEmpty &&
                          _selectedChildIndex < cache.length) {
                        childName = cache[_selectedChildIndex].name;
                        childId = cache[_selectedChildIndex].id;
                      }

                      List<NutritionTodayShoppingItem> shoppingList = [];
                      int mealCount = 0, doneCount = 0, progress = 0;
                      if (menuState is CaregiverTodayMenuLoaded) {
                        shoppingList = menuState.data.shoppingList;
                        mealCount = recipes.length;
                        doneCount = recipes
                            .where((r) => r.portionsConsumed > 0.0)
                            .length;
                        progress = mealCount == 0
                            ? 0
                            : ((doneCount / mealCount) * 100).toInt();
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              const CaregiverHomeHeader(),
                              SizedBox(height: 24.h),

                              // Greeting
                              Text(
                                'Berikut rekomendasi menu untuk\nanak-anak hari ini',
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Child Selector
                              BlocConsumer<
                                CaregiverChildrenCacheCubit,
                                List<ChildHeaderEntity>
                              >(
                                listener: (context, cachedChildren) {
                                  if (cachedChildren.isNotEmpty) {
                                    context
                                        .read<CaregiverTodayMenuCubit>()
                                        .fetchTodayMenu(
                                          cachedChildren[_selectedChildIndex]
                                              .id,
                                        );
                                  }
                                },
                                builder: (context, cachedChildren) {
                                  final pickerData = cachedChildren
                                      .map(
                                        (c) => {
                                          'image': c.imagePath,
                                          'name': c.name,
                                        },
                                      )
                                      .toList();
                                  return CaregiverChildSelector(
                                    children: pickerData,
                                    selectedIndex: _selectedChildIndex,
                                    onChildSelected: (index) =>
                                        _onChildSelected(index, cachedChildren),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),

                              // Loading / Error
                              if (isLoading)
                                Padding(
                                  padding: EdgeInsets.only(top: 60.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A735),
                                    ),
                                  ),
                                )
                              else if (homeError != null || menuError != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 60.h),
                                  child: Center(
                                    child: Text(
                                      homeError ?? menuError ?? 'Error',
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              else if (menuState
                                  is CaregiverTodayMenuLoaded) ...[
                                // Summary Card
                                _buildSummaryCard(
                                  childName,
                                  '$doneCount dari $mealCount selesai',
                                  progress,
                                ),
                                SizedBox(height: 16.h),

                                // Shopping List
                                if (shoppingList.isNotEmpty) ...[
                                  _buildShoppingListCard(shoppingList, childId),
                                  SizedBox(height: 24.h),
                                ],

                                // Meal schedule
                                Text(
                                  'Jadwal Makan',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                _buildMenuRecipes(recipes, childId),
                              ],

                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String fullName,
    String completedText,
    int progress,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu Hari Ini untuk $fullName',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now())} - $completedText',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    color: const Color(0xFF00A735),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7EE),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$progress%',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00A735),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRecipes(List<RecipeEntity> recipes, String childId) {
    if (recipes.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Text(
            'Belum ada rekomendasi menu\nuntuk anak hari ini.',
            style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: recipes
          .map((r) => CaregiverMealCard(recipe: r, childId: childId))
          .toList(),
    );
  }

  Widget _buildShoppingListCard(
    List<NutritionTodayShoppingItem> items,
    String childId,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCF9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Color(0xFF00A735)),
              SizedBox(width: 8.w),
              Text(
                "Daftar Belanja Hari Ini",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...items
              .take(3)
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F4),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Text("🛒", style: TextStyle(fontSize: 16.sp)),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.unit,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          if (items.length > 3) SizedBox(height: 8.h),
          if (items.length > 3)
            Center(
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.caregiverShoppingList.name,
                    pathParameters: {'child_id': childId},
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    "Lihat Selengkapnya",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyConnectionState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.caregiverEmptyChild, height: 220.h),
          SizedBox(height: 24.h),
          Text(
            'Yuk, Hubungkan Profil Anak!',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            'Scan QR dari orang tua untuk mulai melihat informasi dan resep anak yang kamu asuh.',
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoutes.caregiverQR.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A735),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Scan QR',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
