import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/add_growth_report_usecase.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';
import 'add_growth_report_state.dart';

class AddGrowthReportCubit extends Cubit<AddGrowthReportState> {
  final AddGrowthReportUseCase addGrowthReportUseCase;

  AddGrowthReportCubit({required this.addGrowthReportUseCase})
      : super(AddGrowthReportInitial());

  Future<void> submitReport(AddGrowthReportModel params) async {
    emit(AddGrowthReportLoading());

    final result = await addGrowthReportUseCase(params);

    result.fold(
      (failure) => emit(AddGrowthReportError(failure.message)),
      (id) => emit(AddGrowthReportSuccess(id)),
    );
  }
}
