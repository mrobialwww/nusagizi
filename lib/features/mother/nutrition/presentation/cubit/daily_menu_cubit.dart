import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_report_menu_by_id_usecase.dart';

import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_nutrition_today_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/daily_menu_state.dart';

class DailyMenuCubit extends Cubit<DailyMenuState> {
  final GetReportMenuByIdUseCase getReportMenuByIdUseCase;
  final GetNutritionTodayUseCase getNutritionTodayUseCase;

  DailyMenuCubit({
    required this.getReportMenuByIdUseCase,
    required this.getNutritionTodayUseCase,
  }) : super(DailyMenuInitial());

  Future<void> fetchReportMenu(String childId, String reportId) async {
    emit(DailyMenuLoading());
    final result = await getReportMenuByIdUseCase(childId, reportId);
    result.fold(
      (failure) => emit(DailyMenuError(failure.message)),
      (menu) => emit(DailyMenuLoaded(menu)),
    );
  }
}
