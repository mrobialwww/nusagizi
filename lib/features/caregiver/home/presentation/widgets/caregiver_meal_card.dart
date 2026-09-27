import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_completion_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_today_menu_cubit.dart';
import 'package:nusagizi/core/utils/meal_ui_helper.dart';

class CaregiverMealCard extends StatefulWidget {
  final RecipeEntity recipe;
  final String childId;

  const CaregiverMealCard({
    super.key,
    required this.recipe,
    required this.childId,
  });

  @override
  State<CaregiverMealCard> createState() => _CaregiverMealCardState();
}

class _CaregiverMealCardState extends State<CaregiverMealCard> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.recipe.portionsConsumed > 0.0;
  }

  @override
  void didUpdateWidget(covariant CaregiverMealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recipe.portionsConsumed != oldWidget.recipe.portionsConsumed) {
      setState(() {
        _isChecked = widget.recipe.portionsConsumed > 0.0;
      });
    }
  }

  void _toggleCheckbox() {
    if (!_isChecked) {
      _showPortionBottomSheet();
    }
  }

  void _showPortionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CaregiverRecipeCompletionCubit>(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Text(
                "Berapa banyak porsi yang dihabiskan?",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              _buildPortionOption(context, "Kurang dari 1/2 porsi", 0.33),
              Divider(height: 1, color: Colors.grey[300]),
              _buildPortionOption(context, "Lebih dari 1/2 porsi", 0.66),
              Divider(height: 1, color: Colors.grey[300]),
              _buildPortionOption(context, "Habis", 1.0),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortionOption(
    BuildContext context,
    String title,
    double portions,
  ) {
    return InkWell(
      onTap: () {
        context.pop();
        setState(() => _isChecked = true);
        context.read<CaregiverRecipeCompletionCubit>().updateCompletion(
          widget.recipe.id,
          portions,
        );
        context.read<CaregiverTodayMenuCubit>().markRecipeCompleted(
          widget.recipe.id,
          portions,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CAF50);
    // map time
    final profile = MealUiHelper.getProfile(widget.recipe.mealTime);
    IconData icon = profile.icon;
    Color iconColor = profile.iconColor;
    String mealType = profile.mealType;

    final tags = widget.recipe.mealTexture.trim().isNotEmpty
        ? [widget.recipe.mealTexture]
        : <String>[];
    String title = widget.recipe.name;
    double kcal = widget.recipe.calories;
    double protein = widget.recipe.protein;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: _isChecked ? Border.all(color: green, width: 1.5) : null,
          boxShadow: [
            if (!_isChecked)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      mealType,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    widget.recipe.mealTime,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        children: tags.map((tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 10.sp,
                                color: Colors.green[800]!,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 14.sp,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${kcal.toInt()} Kcal",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          if (protein > 0) ...[
                            Icon(
                              Icons.kebab_dining,
                              size: 14.sp,
                              color: Colors.orange[800],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${protein.toInt()} g",
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.caregiverRecipeDetail.name,
                        extra: widget.recipe.id,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _isChecked
                            ? green.withValues(alpha: 0.1)
                            : Colors.white,
                        border: Border.all(
                          color: _isChecked
                              ? green.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Detail Resep",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _isChecked ? green : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_isChecked) ...[
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: _toggleCheckbox,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.check, size: 20.sp, color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
            if (_isChecked) ...[
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.socialCaregiver.name,
                    extra: widget.childId,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Ambil Foto Makanan",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
