import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/recipe_completion_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/recipe_fallback_image.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/core/utils/meal_ui_helper.dart';

class DailyMenuCard extends StatefulWidget {
  final String rawMealTime;
  final String? timeStr;
  final String? mealType;
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;
  final String title;
  final List<String> tags;
  final double kcal;
  final double protein;
  final String? recipeId;
  final String? specialInfo;
  final IconData? specialInfoIcon;
  final Color? specialInfoColor;
  final double? portionsConsumed;

  const DailyMenuCard({
    super.key,
    required this.rawMealTime,
    this.timeStr,
    this.mealType,
    this.icon,
    this.iconColor,
    this.imageUrl,
    required this.title,
    required this.tags,
    required this.kcal,
    required this.protein,
    this.recipeId,
    this.specialInfo,
    this.specialInfoIcon,
    this.specialInfoColor,
    this.portionsConsumed,
  });

  @override
  State<DailyMenuCard> createState() => _DailyMenuCardState();
}

class _DailyMenuCardState extends State<DailyMenuCard> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked =
        (widget.portionsConsumed != null && widget.portionsConsumed! > 0.0);
  }

  @override
  void didUpdateWidget(covariant DailyMenuCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.portionsConsumed != oldWidget.portionsConsumed) {
      if (widget.portionsConsumed != null && widget.portionsConsumed! > 0.0) {
        setState(() {
          _isChecked = true;
        });
      }
    }
  }

  void _toggleCheckbox() {
    if (!_isChecked) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        builder: (context) => Container(
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
              _buildPortionOption("Kurang dari 1/2 porsi", 0.33),
              Divider(height: 1, color: Colors.grey[300]),
              _buildPortionOption("Lebih dari 1/2 porsi", 0.66),
              Divider(height: 1, color: Colors.grey[300]),
              _buildPortionOption("Habis", 1.0),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPortionOption(String title, double portions) {
    return InkWell(
      onTap: () {
        context.pop(); // Close bottom sheet
        setState(() => _isChecked = true);
        context.read<RecipeCompletionCubit>().updateCompletion(
          widget.recipeId!,
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

  void _goToSocialTab(BuildContext context) {
    motherNavTabNotifier.value = 1;
    context.goNamed(AppRoutes.socialMother.name);
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CAF50);

    final profile = MealUiHelper.getProfile(widget.rawMealTime);
    IconData buildIcon = widget.icon ?? profile.icon;
    Color buildIconColor = widget.iconColor ?? profile.iconColor;
    String buildMealType = widget.mealType ?? profile.mealType;
    String buildTimeStr = widget.timeStr ?? profile.timeStr;
    final safeProvider = ImageHelper.getSafeImageProvider(widget.imageUrl);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: _isChecked ? Border.all(color: green, width: 1.5) : null,
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
                      child: Icon(
                        buildIcon,
                        color: buildIconColor,
                        size: 20.sp,
                      ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
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
                            "${widget.kcal.toMacroFormat()} Kcal",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          if (widget.specialInfo != null &&
                              widget.specialInfoIcon != null) ...[
                            Icon(
                              widget.specialInfoIcon,
                              size: 14.sp,
                              color: widget.specialInfoColor ?? Colors.blue,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.specialInfo!,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else if (widget.protein > 0) ...[
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
                    onTap: () {
                      if (widget.recipeId != null) {
                        context.pushNamed(
                          AppRoutes.recipeDetail.name,
                          extra: widget.recipeId,
                        );
                      }
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
                        color: _isChecked
                            ? green
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 20.sp,
                        color: _isChecked ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (_isChecked) ...[
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => _goToSocialTab(context),
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
