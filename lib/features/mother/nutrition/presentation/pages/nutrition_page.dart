import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/core/widgets/headers/header_primary_features.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:nusagizi/core/widgets/headers/appbar_action_button.dart';
import 'package:nusagizi/core/widgets/child_picker_bottom_sheet.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/daily_menu_card.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_today_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_today_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_state.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_state.dart';
import 'dart:async';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/midnight_sync_cubit.dart';

class NutritionPage extends StatefulWidget {
  final String? initialChildId;

  const NutritionPage({super.key, this.initialChildId});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  late final AppLifecycleListener _lifecycleListener;
  bool _wasPaused = false;
  int _selectedChildIndex = 0;
  bool _showShoppingList = true;
  final _nutritionTodayCubit = sl<NutritionTodayCubit>();

  final _syncCubit = sl<MidnightSyncCubit>();
  Timer? _midnightTimer;
  late final GoRouterDelegate _routerDelegate;

  @override
  void initState() {
    super.initState();
    sl<ChildrenCacheCubit>().fetchIfEmpty();
    _lifecycleListener = AppLifecycleListener(
      onPause: () => _wasPaused = true,
      onResume: () {
        if (_wasPaused) _checkAndGenerate();
        _wasPaused = false;
      },
    );
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);

    _initializeSelectedChild();

    final cacheState = sl<ChildrenCacheCubit>().state;
    // Fetch data for the first child if available
    if (cacheState.isNotEmpty) {
      _nutritionTodayCubit.fetchNutritionToday(
        cacheState[_selectedChildIndex].id,
      );
    }
    _checkAndGenerate();
    _scheduleMidnightTimer();
  }

  void _initializeSelectedChild() {
    if (widget.initialChildId != null) {
      final cacheState = sl<ChildrenCacheCubit>().state;
      if (cacheState.isNotEmpty) {
        final index = cacheState.indexWhere(
          (c) => c.id == widget.initialChildId,
        );
        if (index != -1) {
          _selectedChildIndex = index;
        }
      }
    }
  }

  void _checkAndGenerate() {
    if (_syncCubit.needsGenerate) {
      sl<MenuActionCubit>().generateMenu();
      _syncCubit.markGeneratedToday();
    }
  }

  void _scheduleMidnightTimer() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final delay = nextMidnight.difference(now);

    _midnightTimer = Timer(delay, () {
      _checkAndGenerate();
      _scheduleMidnightTimer(); // reschedule for tommorow
    });
  }

  // Refetch on return if a child page triggered a CRUD operation.
  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final location = _routerDelegate.currentConfiguration.uri.toString();
      if (location == '/home-mother/nutrition' &&
          motherNavTabNotifier.value == 0) {
        if (crudFlag) {
          _refetch();
          crudFlag = false;
        }
      }
    } catch (_) {}
  }

  // Fetch latest nutrition data for the active child.
  void _refetch() {
    if (!mounted) return;
    final cacheState = sl<ChildrenCacheCubit>().state;
    if (cacheState.isNotEmpty && _selectedChildIndex < cacheState.length) {
      _nutritionTodayCubit.fetchNutritionToday(
        cacheState[_selectedChildIndex].id,
      );
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _routerDelegate.removeListener(_onRouteChanged);
    _midnightTimer?.cancel();
    _nutritionTodayCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF00A735);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ChildrenCacheCubit>()),
        BlocProvider.value(value: _nutritionTodayCubit),
        BlocProvider(create: (_) => sl<RecipeCompletionCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          // It automatically fetches the child's nutrition data the exact moment their profile is loaded into the app's cache for the very first time.
          BlocListener<ChildrenCacheCubit, List<ChildHeaderEntity>>(
            listenWhen: (prev, curr) => prev.isEmpty && curr.isNotEmpty,
            listener: (context, children) {
              if (!mounted) return;
              final initialId = widget.initialChildId;
              final index = initialId != null
                  ? children.indexWhere((c) => c.id == initialId)
                  : -1;
              final targetIndex = index != -1 ? index : 0;
              setState(() => _selectedChildIndex = targetIndex);
              _nutritionTodayCubit.fetchNutritionToday(
                children[targetIndex].id,
              );
            },
          ),
          BlocListener<MenuActionCubit, MenuActionState>(
            bloc: sl<MenuActionCubit>(),
            listener: (context, state) {
              // Reactively fetch today's nutrition data upon successful menu updates
              if (state is MenuActionReuseSuccess ||
                  state is MenuActionGenerateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Menu berhasil di-generate!"),
                    backgroundColor: Colors.green,
                  ),
                );
                sl<MenuActionCubit>().resetState();
                final childrenList = sl<ChildrenCacheCubit>().state;
                if (childrenList.isNotEmpty) {
                  final validIndex = _selectedChildIndex < childrenList.length
                      ? _selectedChildIndex
                      : 0;
                  _nutritionTodayCubit.fetchNutritionToday(
                    childrenList[validIndex].id,
                  );
                }
              } else if (state is MenuActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal generate: ${state.message}"),
                    backgroundColor: Colors.red,
                  ),
                );
                sl<MenuActionCubit>().resetState();
              }
            },
          ),
          BlocListener<RecipeCompletionCubit, RecipeCompletionState>(
            listener: (context, state) {
              if (state is RecipeCompletionSuccess) {
                final childrenList = sl<ChildrenCacheCubit>().state;
                if (childrenList.isNotEmpty) {
                  final validIndex = _selectedChildIndex < childrenList.length
                      ? _selectedChildIndex
                      : 0;
                  _nutritionTodayCubit.fetchNutritionToday(
                    childrenList[validIndex].id,
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
          builder: (context, childrenList) {
            if (childrenList.isEmpty) {
              return const Scaffold(
                body: Center(child: Text('Belum ada data anak.')),
              );
            }

            final validChild = _selectedChildIndex < childrenList.length
                ? childrenList[_selectedChildIndex]
                : childrenList.first;

            final validIndex = _selectedChildIndex < childrenList.length
                ? _selectedChildIndex
                : 0;

            return BlocBuilder<MenuActionCubit, MenuActionState>(
              bloc: sl<MenuActionCubit>(),
              builder: (context, menuActionState) {
                return BlocBuilder<
                  RecipeCompletionCubit,
                  RecipeCompletionState
                >(
                  builder: (context, completionState) {
                    return BlocBuilder<
                      NutritionTodayCubit,
                      NutritionTodayState
                    >(
                      builder: (context, state) {
                        final isGenerating =
                            menuActionState is MenuActionGenerateLoading;
                        bool isMenuEmpty = false;

                        if (state is NutritionTodayLoaded) {
                          if (state.data.menu == null ||
                              state.data.menu!.recipes.isEmpty) {
                            isMenuEmpty = true;
                          }
                        }

                        if (isGenerating || isMenuEmpty) {
                          return _buildGeneratingMenuScreen();
                        }

                        return Scaffold(
                          backgroundColor: const Color(0xFFF7F7F7),
                          appBar: HeaderPrimaryFeatures(
                            profile: validChild,
                            accentColor: accentColor,
                            onPickerTapped: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return BlocProvider.value(
                                    value: sl<ChildrenCacheCubit>(),
                                    child: ChildPickerBottomSheet(
                                      selectedIndex: validIndex,
                                      onChildSelected: (index) {
                                        setState(() {
                                          _selectedChildIndex = index;
                                          _showShoppingList = true;
                                        });
                                        _nutritionTodayCubit
                                            .fetchNutritionToday(
                                              childrenList[index].id,
                                            );
                                      },
                                      accentColor: accentColor,
                                    ),
                                  );
                                },
                              );
                            },
                            actions: [
                              AppbarActionButton(
                                icon: Icons.history_rounded,
                                onTap: () => context.goNamed(
                                  AppRoutes.nutritionHistory.name,
                                  extra: validChild,
                                ),
                              ),
                              AppbarActionButton(
                                icon: Icons.bookmark_border_rounded,
                                onTap: () => context.goNamed(
                                  AppRoutes.savedRecipe.name,
                                  extra: validChild.id,
                                ),
                              ),
                            ],
                          ),
                          body: SafeArea(
                            child: Builder(
                              builder: (context) {
                                if (state is NutritionTodayLoading ||
                                    completionState
                                        is RecipeCompletionLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: accentColor,
                                    ),
                                  );
                                } else if (state is NutritionTodayError) {
                                  return Center(child: Text(state.message));
                                } else if (state is NutritionTodayLoaded) {
                                  final data = state.data;

                                  return SingleChildScrollView(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildNutritionStatusCard(data),
                                        if (data.hasAnyNutrition) ...[
                                          SizedBox(height: 16.h),
                                          _buildInsightCard(
                                            data,
                                            validChild.name,
                                          ),
                                        ],
                                        SizedBox(height: 16.h),
                                        if (_showShoppingList &&
                                            data.shoppingList.isNotEmpty)
                                          _buildShoppingListCard(
                                            data.shoppingList,
                                          ),
                                        SizedBox(height: 24.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Menu Hari ini",
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final shouldRefresh =
                                                    await context
                                                        .pushNamed<bool>(
                                                          AppRoutes
                                                              .nutritionAllMenu
                                                              .name,
                                                          extra: {
                                                            'childId':
                                                                validChild.id,
                                                            'reportId': data.id,
                                                          },
                                                        );
                                                if (shouldRefresh == true &&
                                                    context.mounted) {
                                                  _nutritionTodayCubit
                                                      .fetchNutritionToday(
                                                        validChild.id,
                                                      );
                                                }
                                              },
                                              child: Text(
                                                "Lihat Semua",
                                                style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildMenuRecipes(data),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Full-screen loading UI saat menu sedang di-generate oleh backend (midnight job).
  Widget _buildGeneratingMenuScreen() {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF00A735)),
                  SizedBox(height: 32.h),
                  Text(
                    'Sedang menyiapkan menu hari ini...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'AI sedang memilihkan resep terbaik untuk si kecil. Ini hanya membutuhkan beberapa saat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRecipes(NutritionTodayEntity data) {
    return Column(
      children: data.menu!.recipes.map((recipe) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: DailyMenuCard(
            rawMealTime: recipe.mealTime,
            imageUrl: recipe.imageUrl,
            title: recipe.name,
            tags: recipe.mealTexture.trim().isNotEmpty
                ? [recipe.mealTexture]
                : [],
            kcal: recipe.calories,
            protein: recipe.protein,
            recipeId: recipe.id,
            portionsConsumed: recipe.portionsConsumed,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutritionStatusCard(NutritionTodayEntity data) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status Gizi Hari Ini",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(data.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8.sp,
                      color: _getStatusColor(data.status),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      data.status,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.sp,
                        color: _getStatusColor(data.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.calories.toMacroFormat(),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                " / ${data.targetCalories.toMacroFormat()} kcal",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildProgressBar(
                  "Protein",
                  "${data.protein.toMacroFormat()}g",
                  "${data.targetProtein.toMacroFormat()}g",
                  data.targetProtein > 0
                      ? data.protein / data.targetProtein
                      : 0.0,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildProgressBar(
                  "Lemak",
                  "${data.fat.toMacroFormat()}g",
                  "${data.targetFat.toMacroFormat()}g",
                  data.targetFat > 0 ? data.fat / data.targetFat : 0.0,
                  Colors.green,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildProgressBar(
                  "Karbo",
                  "${data.carbohydrate.toMacroFormat()}g",
                  "${data.targetCarbohydrate.toMacroFormat()}g",
                  data.targetCarbohydrate > 0
                      ? data.carbohydrate / data.targetCarbohydrate
                      : 0.0,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'kurang optimal':
        return Colors.orange;
      case 'berisiko':
        return Colors.deepOrange;
      case 'sangat buruk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildProgressBar(
    String title,
    String current,
    String total,
    double progress,
    Color color,
  ) {
    // clamp progress
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "$current/$total",
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingListCard(List<NutritionTodayShoppingItem> items) {
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
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
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
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.unit,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
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
                  context.pushNamed(AppRoutes.shoppingList.name);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    "Lihat Selengkapnya",
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
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

  Widget _buildInsightCard(NutritionTodayEntity data, String childName) {
    double proteinPercentage = data.targetProtein > 0
        ? (data.protein / data.targetProtein)
        : 0.0;
    double fatPercentage = data.targetFat > 0
        ? (data.fat / data.targetFat)
        : 0.0;
    double karboPercentage = data.targetCarbohydrate > 0
        ? (data.carbohydrate / data.targetCarbohydrate)
        : 0.0;

    String highestNutrientName = 'protein';
    double highestPercentage = proteinPercentage;

    if (fatPercentage > highestPercentage) {
      highestNutrientName = 'lemak';
      highestPercentage = fatPercentage;
    }

    if (karboPercentage > highestPercentage) {
      highestNutrientName = 'karbohidrat';
      highestPercentage = karboPercentage;
    }

    highestPercentage = highestPercentage.clamp(0.0, 1.0);
    final int displayPercentage = (highestPercentage * 100).toInt();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb, color: Color(0xFF00A735)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Insight Hari Ini",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13.sp,
                      color: Colors.black87,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: "Asupan "),
                      TextSpan(
                        text: highestNutrientName,
                        style: const TextStyle(
                          color: Color(0xFF00A735),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            " $childName hari ini sudah tercapai $displayPercentage%. Teruskan!",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
