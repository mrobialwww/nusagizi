import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_children_summary_usecase.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_state.dart';

class MotherHomeCubit extends Cubit<MotherHomeState> {
  final GetChildrenSummaryUseCase getChildrenSummaryUseCase;
  MotherHomeCubit({required this.getChildrenSummaryUseCase})
    : super(MotherHomeInitial());

  Future<void> getChildrenSummary() async {
    emit(MotherHomeLoading());

    final result = await getChildrenSummaryUseCase();
    result.fold((failure) => emit(MotherHomeError(message: failure.message)), (
      children,
    ) {
      emit(MotherHomeLoaded(children: children));
    });
  }
}
