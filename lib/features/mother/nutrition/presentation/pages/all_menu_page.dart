import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/daily_menu_card.dart';
import 'package:nusagizi/router.dart';

class AllMenuPage extends StatefulWidget {
  final String? childId;
  final String? reportId;

  const AllMenuPage({super.key, this.childId, this.reportId});

  @override
  State<AllMenuPage> createState() => _AllMenuPageState();
}

class _AllMenuPageState extends State<AllMenuPage> {
  late final DailyMenuCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DailyMenuCubit>();
    if (widget.childId != null && widget.reportId != null) {
      _cubit.fetchReportMenu(widget.childId!, widget.reportId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeCompletionCubit>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<MenuActionCubit, MenuActionState>(
            bloc: sl<MenuActionCubit>(),
            listener: (context, state) {
              if (state is MenuActionGenerateSuccess) {
                context.pop(true);
              }
            },
          ),
          BlocListener<RecipeCompletionCubit, RecipeCompletionState>(
            listener: (context, state) {
              if (state is RecipeCompletionSuccess) {
                if (widget.childId != null && widget.reportId != null) {
                  _cubit.fetchReportMenu(widget.childId!, widget.reportId!);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<MenuActionCubit, MenuActionState>(
          bloc: sl<MenuActionCubit>(),
          builder: (context, actionState) {
            if (actionState is MenuActionGenerateLoading ||
                actionState is MenuActionGenerateSuccess) {
              return Scaffold(
                backgroundColor: const Color(0xFFF3F4F6),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFF00A735)),
                      SizedBox(height: 24.h),
                      Text(
                        "menu baru sedang di generate....",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return BlocBuilder<DailyMenuCubit, DailyMenuState>(
              bloc: _cubit,
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: const Color(0xFFF3F4F6),
                  appBar: const HeaderBasic(
                    backgroundColor: Color(0xFFF3F4F6),
                    title: "Menu Hari ini",
                  ),
                  body: BlocBuilder<RecipeCompletionCubit, RecipeCompletionState>(
                    builder: (context, completionState) {
                      if (state is DailyMenuLoading ||
                          completionState is RecipeCompletionLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A735),
                          ),
                        );
                      }

                      return ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        children: [
                          Text(
                            "Hari ini, ${DateFormat("d MMMM", "id_ID").format(DateTime.now())}",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if (state is DailyMenuError)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.w),
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          if (state is DailyMenuLoaded) ...[
                            ...state.menu.recipes.map(
                              (recipe) => _buildMenuCard(recipe),
                            ),
                            BlocBuilder<
                              RecipeCompletionCubit,
                              RecipeCompletionState
                            >(
                              builder: (context, completionState) {
                                final isCompletedLocally =
                                    completionState
                                        is RecipeCompletionLoading ||
                                    completionState is RecipeCompletionSuccess;

                                final isCompletedInServer = state.menu.recipes
                                    .any((r) => r.portionsConsumed > 0);

                                if (isCompletedLocally || isCompletedInServer) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 24.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF57C00),
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 56.w,
                                            height: 56.w,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 36.w,
                                              height: 36.w,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF57C00),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.priority_high,
                                                color: Colors.white,
                                                size: 22.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Text(
                                            'Menu hari ini sudah tersedia',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Kamu sudah memasak salah satu menu hari ini. Buat menu baru akan tersedia lagi besok.',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                // Belum ada menu yang dimasak — tampilkan kotak saran
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: Container(
                                    padding: EdgeInsets.all(24.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2EAE1),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 56.w,
                                          height: 56.w,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 28.w,
                                            height: 28.w,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF57C00),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.priority_high,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          "Belum cocok dengan menu ini?",
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "Sesuaikan rekomendasi berdasarkan bahan,\npreferensi, atau kondisi yang perlu diperhatikan.",
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            height: 1.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 24.h),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              if (widget.childId != null &&
                                                  widget.reportId != null) {
                                                sl<MenuActionCubit>()
                                                    .generateMenu();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFF57C00,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              elevation: 0,
                                            ),
                                            icon: Icon(
                                              Icons.shuffle,
                                              size: 18.sp,
                                            ),
                                            label: Text(
                                              "Buat Menu Baru",
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          child: Text(
                                            "atau",
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              context.goNamed(
                                                AppRoutes.noteMother.name,
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(
                                                0xFFF57C00,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFFF57C00),
                                              ),
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.medical_services_outlined,
                                              size: 18.sp,
                                            ),
                                            label: Text(
                                              "Tambah Catatan Konsultasi Dokter",
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(recipe) {
    List<String> displayTags = [];
    if (recipe.mealTexture.trim().isNotEmpty) {
      displayTags.add(recipe.mealTexture);
    }
    if (recipe.mealTime == 'afternoon_snack' ||
        recipe.mealTime == 'morning_snack') {
      if (!displayTags.contains('Alami')) {
        displayTags = ['Alami'];
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: DailyMenuCard(
        rawMealTime: recipe.mealTime,
        imageUrl: recipe.imageUrl,
        title: recipe.name,
        tags: displayTags,
        kcal: recipe.calories,
        protein: recipe.protein,
        recipeId: recipe.id,
        portionsConsumed: recipe.portionsConsumed,
      ),
    );
  }
}
