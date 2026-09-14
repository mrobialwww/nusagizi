import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_nutrition_reports_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_history_state.dart';

class NutritionHistoryCubit extends Cubit<NutritionHistoryState> {
  final GetNutritionReportsUseCase getNutritionReportsUseCase;

  NutritionHistoryCubit({required this.getNutritionReportsUseCase})
    : super(NutritionHistoryInitial());

  Future<void> fetchReports(String childId, int month, int year) async {
    emit(NutritionHistoryLoading());
    final result = await getNutritionReportsUseCase(childId, month, year);

    result.fold(
      (failure) => emit(NutritionHistoryError(failure.message)),
      (reports) => emit(NutritionHistoryLoaded(reports)),
    );
  }
}
