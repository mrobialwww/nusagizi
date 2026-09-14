import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_summary.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_state.dart';

class DevelopmentCubit extends Cubit<DevelopmentState> {
  DevelopmentCubit(this._getChildDevelopmentSummary)
    : super(const DevelopmentInitial());

  final GetChildDevelopmentSummary _getChildDevelopmentSummary;

  Future<void> loadSummary(String childId) async {
    emit(const DevelopmentLoading());
    final result = await _getChildDevelopmentSummary(childId);

    result.fold(
      (failure) => emit(DevelopmentError(failure.message)),
      (summary) => emit(DevelopmentLoaded(summary)),
    );
  }
}
