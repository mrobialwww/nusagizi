import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/saved_menu_card.dart';

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
                          style: GoogleFonts.outfit(
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
                  return _buildEmptyState();
                }
                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: state.recipes
                      .map((recipe) => _buildMenuCard(recipe))
                      .toList(),
                );
              }
              return _buildEmptyState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'Belum ada resep tersimpan',
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tekan ikon bookmark pada halaman\ndetail resep untuk menyimpan resep.',
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.grey[400],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
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
