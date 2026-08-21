import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';

class RecipeIngredients extends StatelessWidget {
  final RecipeDetailEntity data;

  const RecipeIngredients({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.grain,
      Icons.set_meal,
      Icons.grass,
      Icons.eco,
      Icons.soup_kitchen,
      Icons.oil_barrel,
    ];

    final allItemsCount =
        data.mainIngredients.length + data.recipeSpices.length;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bahan Utama",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$allItemsCount item",
                style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...data.mainIngredients.asMap().entries.map((entry) {
            int idx = entry.key;
            final item = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              icons[idx % icons.length],
                              color: Colors.grey[600],
                            ),
                          )
                        : Icon(
                            icons[idx % icons.length],
                            color: Colors.grey[600],
                          ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.isNotEmpty ? item.name : 'Bahan',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          item.unit,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          ...data.recipeSpices.asMap().entries.map((entry) {
            int idx = entry.key + data.mainIngredients.length;
            final spice = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      icons[idx % icons.length],
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spice.name,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          spice.unit,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
