import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_latest_growth_report_usecase.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/latest_growth_report_state.dart';

class LatestGrowthReportCubit extends Cubit<LatestGrowthReportState> {
  final GetLatestGrowthReportUseCase getLatestGrowthReportUseCase;

  LatestGrowthReportCubit({required this.getLatestGrowthReportUseCase})
      : super(LatestGrowthReportInitial());

  Future<void> fetchLatestGrowthReport(String childId) async {
    emit(LatestGrowthReportLoading());

    final result = await getLatestGrowthReportUseCase(childId);

    result.fold(
      (failure) => emit(LatestGrowthReportError(message: failure.message)),
      (data) => emit(LatestGrowthReportSuccess(data: data)),
    );
  }
}
