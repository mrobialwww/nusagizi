import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/history_menu_card.dart';

class HistoryMenuPage extends StatefulWidget {
  final String? childId;
  final String? reportId;
  final String? dateStr;

  const HistoryMenuPage({super.key, this.childId, this.reportId, this.dateStr});

  @override
  State<HistoryMenuPage> createState() => _HistoryMenuPageState();
}

class _HistoryMenuPageState extends State<HistoryMenuPage> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const HeaderBasic(
        backgroundColor: Color(0xFFF3F4F6),
        title: "Resep yang Dimasak",
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          Text(
            widget.dateStr ?? "Detail Menu",
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<DailyMenuCubit, DailyMenuState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is DailyMenuLoading) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: CircularProgressIndicator(color: Color(0xFF00A735)),
                  ),
                );
              } else if (state is DailyMenuError) {
                return Center(
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
                );
              } else if (state is DailyMenuLoaded) {
                return Column(
                  children: [
                    ...state.menu.recipes.map(
                      (recipe) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: HistoryMenuCard(
                          rawMealTime: recipe.mealTime,
                          imageUrl: recipe.imageUrl,
                          title: recipe.name,
                          portionsConsumed: recipe.portionsConsumed,
                          recipeId: recipe.id,
                          childId: widget.childId!,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
