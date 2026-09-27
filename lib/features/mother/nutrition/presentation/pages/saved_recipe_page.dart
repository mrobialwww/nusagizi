import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/saved_menu_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/config/assets/app_vectors.dart';
import 'package:nusagizi/router.dart';

class SavedRecipePage extends StatelessWidget {
  final String? childId;

  const SavedRecipePage({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<SavedRecipeCubit>();
            if (childId != null) {
              cubit.fetchSavedRecipes(childId!);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: const HeaderBasic(
          backgroundColor: Color(0xFFF7F7F7),
          title: 'Resep Tersimpan',
        ),
        body: SafeArea(
          child: BlocBuilder<SavedRecipeCubit, SavedRecipeState>(
            builder: (context, state) {
              if (state is SavedRecipeLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00A735)),
                );
              } else if (state is SavedRecipeError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is SavedRecipeLoaded) {
                if (state.recipes.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: state.recipes
                      .map((recipe) => _buildMenuCard(recipe))
                      .toList(),
                );
              }
              return _buildEmptyState(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppVectors.emptySearch, height: 200.h),
                SizedBox(height: 24.h),
                Text(
                  'Belum Ada Resep Tersimpan',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Simpan resep favorit si kecil di sini agar mudah ditemukan saat dibutuhkan nanti.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    color: Colors.black54,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.nutritionAllMenu.name,
                  extra: {'childId': childId},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A735),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Lihat Menu Hari Ini',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(RecipeEntity recipe) {
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
      child: SavedMenuCard(
        rawMealTime: recipe.mealTime,
        imageUrl: recipe.imageUrl,
        title: recipe.name,
        tags: displayTags,
        calories: recipe.calories,
        protein: recipe.protein,
        recipeId: recipe.id,
        childId: childId!,
      ),
    );
  }
}
