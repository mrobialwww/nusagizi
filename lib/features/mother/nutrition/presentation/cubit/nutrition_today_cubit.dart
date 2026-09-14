import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/nutrition/domain/usecases/get_nutrition_today_usecase.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/nutrition_today_state.dart';

class NutritionTodayCubit extends Cubit<NutritionTodayState> {
  final GetNutritionTodayUseCase getNutritionTodayUseCase;

  NutritionTodayCubit({required this.getNutritionTodayUseCase})
    : super(NutritionTodayInitial());

  Future<void> fetchNutritionToday(String childId) async {
    emit(NutritionTodayLoading());
    final now = DateTime.now();
    final result = await getNutritionTodayUseCase(childId, now);

    result.fold(
      (failure) => emit(NutritionTodayError(message: failure.message)),
      (data) => emit(NutritionTodayLoaded(data: data)),
    );
  }
}
