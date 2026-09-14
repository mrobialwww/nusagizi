import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_ingredients.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_detail_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_detail_state.dart';
import 'package:nusagizi/features/caregiver/home/presentation/widgets/caregiver_recipe_steps.dart';

class CaregiverRecipeDetailPage extends StatefulWidget {
  final String recipeId;
  const CaregiverRecipeDetailPage({super.key, required this.recipeId});

  @override
  State<CaregiverRecipeDetailPage> createState() =>
      _CaregiverRecipeDetailPageState();
}

class _CaregiverRecipeDetailPageState extends State<CaregiverRecipeDetailPage> {
  late final CaregiverRecipeDetailCubit _recipeDetailCubit;

  @override
  void initState() {
    super.initState();
    _recipeDetailCubit = sl<CaregiverRecipeDetailCubit>();
    if (widget.recipeId.isNotEmpty) {
      _recipeDetailCubit.fetchRecipeDetail(widget.recipeId);
    }
  }

  @override
  void dispose() {
    _recipeDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _recipeDetailCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: const HeaderBasic(
          backgroundColor: Color(0xFFF7F7F7),
          title: "Detail Resep",
        ),
        body:
            BlocBuilder<CaregiverRecipeDetailCubit, CaregiverRecipeDetailState>(
              builder: (context, state) {
                if (state is CaregiverRecipeDetailLoading ||
                    state is CaregiverRecipeDetailInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A735)),
                  );
                } else if (state is CaregiverRecipeDetailError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is CaregiverRecipeDetailLoaded) {
                  final data = state.recipeDetail;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(data),
                            _buildNutritionInfo(data),
                            RecipeIngredients(data: data),
                            CaregiverRecipeSteps(data: data),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
      ),
    );
  }

  Widget _buildHeader(RecipeDetailEntity data) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              "https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&q=80&w=600",
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  data.mealTexture,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            data.name,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            data.description,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(RecipeDetailEntity data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0.h),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Gizi",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionItem(
                  Icons.local_fire_department,
                  const Color(0xFFFF9800),
                  data.calories.toMacroFormat(),
                  "Kkal",
                ),
                _buildNutritionItem(
                  Icons.local_dining,
                  const Color(0xFFF44336),
                  "${data.protein}g",
                  "Protein",
                ),
                _buildNutritionItem(
                  Icons.grass,
                  const Color(0xFFFFC107),
                  "${data.carbohydrate}g",
                  "Karbo",
                ),
                _buildNutritionItem(
                  Icons.water_drop,
                  const Color(0xFF2196F3),
                  "${data.fat}g",
                  "Lemak",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 10.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
