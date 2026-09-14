import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_history_usecase.dart';
import 'growth_history_state.dart';

class GrowthHistoryCubit extends Cubit<GrowthHistoryState> {
  final GetGrowthHistoryUseCase getGrowthHistoryUseCase;

  GrowthHistoryCubit({required this.getGrowthHistoryUseCase})
    : super(GrowthHistoryInitial());

  Future<void> fetchHistory(String childId) async {
    emit(GrowthHistoryLoading());
    final result = await getGrowthHistoryUseCase(childId);
    result.fold(
      (failure) => emit(GrowthHistoryError(failure.message)),
      (history) => emit(GrowthHistoryLoaded(history)),
    );
  }
}
