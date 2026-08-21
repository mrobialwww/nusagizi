import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_history.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_history_state.dart';

class DevelopmentHistoryCubit extends Cubit<DevelopmentHistoryState> {
  DevelopmentHistoryCubit(this.getHistoryUseCase)
    : super(const DevelopmentHistoryInitial());

  final GetChildDevelopmentHistory getHistoryUseCase;

  Future<void> loadHistory(String childId) async {
    emit(const DevelopmentHistoryLoading());
    final result = await getHistoryUseCase(childId);
    result.fold(
      (failure) => emit(DevelopmentHistoryError(failure.message)),
      (history) => emit(DevelopmentHistoryLoaded(history)),
    );
  }
}
