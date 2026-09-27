import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_detail_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_detail_state.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_fallback_image.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_ingredients.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_steps.dart';

class RecipeDetailPage extends StatefulWidget {
  final String? recipeId;

  const RecipeDetailPage({super.key, this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late final RecipeDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<RecipeDetailCubit>();
    if (widget.recipeId != null && widget.recipeId!.isNotEmpty) {
      _cubit.fetchRecipeDetail(widget.recipeId!);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const HeaderBasic(
        backgroundColor: Color(0xFFF7F7F7),
        title: "Detail Resep",
      ),
      body: BlocConsumer<RecipeDetailCubit, RecipeDetailState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is BookmarkSuccess) {
            final msg = state.recipeDetail.isBookmarked
                ? 'Berhasil menyimpan resep'
                : 'Berhasil menghapus dari simpanan';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFF00A735),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          } else if (state is BookmarkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RecipeDetailLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: const CircularProgressIndicator(
                  color: Color(0xFF00A735),
                ),
              ),
            );
          } else if (state is RecipeDetailError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          } else if (state is RecipeDetailLoaded ||
              state is BookmarkSuccess ||
              state is BookmarkError) {
            final data = state is RecipeDetailLoaded
                ? state.recipeDetail
                : state is BookmarkSuccess
                ? state.recipeDetail
                : (state as BookmarkError).recipeDetail;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(data),
                  _buildNutritionInfo(data),
                  RecipeIngredients(data: data),
                  RecipeSteps(data: data),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              "Tidak ada data resep",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(RecipeDetailEntity data) {
    List<String> tags = [];
    if (data.mealTexture.trim().isNotEmpty) {
      tags.add(data.mealTexture);
    }
    final safeProvider = ImageHelper.getSafeImageProvider(data.imageUrl);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: safeProvider != null
                ? Image(
                    image: safeProvider,
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        RecipeFallbackImage(height: 200.h, iconSize: 48.sp),
                  )
                : RecipeFallbackImage(height: 200.h, iconSize: 48.sp),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              ...tags.map((tag) {
                return Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }),
              const Spacer(),
              IconButton(
                onPressed: () {
                  _cubit.toggleBookmark();
                },
                icon: Icon(
                  data.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.black87,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            data.name,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          if (data.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              data.description,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
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
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
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
                  "${data.protein.toMacroFormat()}g",
                  "Protein",
                ),
                _buildNutritionItem(
                  Icons.grass,
                  const Color(0xFFFFC107),
                  "${data.carbohydrate.toMacroFormat()}g",
                  "Karbo",
                ),
                _buildNutritionItem(
                  Icons.water_drop,
                  const Color(0xFF2196F3),
                  "${data.fat.toMacroFormat()}g",
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
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
