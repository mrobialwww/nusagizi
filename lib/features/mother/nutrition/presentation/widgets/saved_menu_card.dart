import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/menu_action_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/saved_recipe_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_fallback_image.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/core/utils/meal_ui_helper.dart';

class SavedMenuCard extends StatefulWidget {
  final String rawMealTime;
  final String? timeStr;
  final String? mealType;
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;
  final String title;
  final List<String> tags;
  final double calories;
  final double protein;
  final String recipeId;
  final String childId;
  const SavedMenuCard({
    super.key,
    required this.rawMealTime,
    this.timeStr,
    this.mealType,
    this.icon,
    this.iconColor,
    this.imageUrl,
    required this.title,
    required this.tags,
    required this.calories,
    required this.protein,
    required this.recipeId,
    required this.childId,
  });

  @override
  State<SavedMenuCard> createState() => _SavedMenuCardState();
}

class _SavedMenuCardState extends State<SavedMenuCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CAF50);

    final profile = MealUiHelper.getProfile(widget.rawMealTime);
    IconData buildIcon = widget.icon ?? profile.icon;
    Color buildIconColor = widget.iconColor ?? profile.iconColor;
    String buildMealType = widget.mealType ?? profile.mealType;
    String buildTimeStr = widget.timeStr ?? profile.timeStr;
    final safeProvider = ImageHelper.getSafeImageProvider(widget.imageUrl);
    ImageHelper.getSafeImageProvider(widget.imageUrl);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                      color: buildIconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(buildIcon, color: buildIconColor, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    buildMealType,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  buildTimeStr,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
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
                child: safeProvider != null
                    ? Image(
                        image: safeProvider,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            RecipeFallbackImage(width: 80.w, height: 80.w),
                      )
                    : RecipeFallbackImage(width: 80.w, height: 80.w),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: widget.tags.map((tag) {
                        Color bgColor = Colors.green.withValues(alpha: 0.1);
                        Color textColor = Colors.green[800]!;

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 10.sp,
                              color: textColor,
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
                          "${widget.calories.toMacroFormat()} Kcal",
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        if (widget.protein != 0) ...[
                          Icon(
                            Icons.kebab_dining, // closer to chicken leg
                            size: 14.sp,
                            color: Colors.orange[800],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.protein.toMacroFormat()} g P",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
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
                  onTap: _isLoading
                      ? null
                      : () async {
                          // Use local state to prevent global loading glitches across cards
                          setState(() => _isLoading = true);

                          // Execute the backend logic for reusing the recipe
                          await sl<MenuActionCubit>().reuseRecipe(
                            childId: widget.childId,
                            sourceRecipeId: widget.recipeId,
                          );

                          if (!context.mounted) return;

                          // Turn off the local card's loading indicator and navigate
                          setState(() => _isLoading = false);
                          context.goNamed(AppRoutes.nutrition.name);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Berhasil memasak lagi resep ini untuk hari ini",
                              ),
                              backgroundColor: green,
                            ),
                          );
                        },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey[400] : green,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: _isLoading
                        ? SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF00A735),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Masak Lagi",
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
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  context.read<SavedRecipeCubit>().removeBookmark(
                    widget.recipeId,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.bookmark, // Solid bookmark as it is saved
                    size: 20.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
