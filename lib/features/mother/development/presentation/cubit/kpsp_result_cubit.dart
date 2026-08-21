import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_child_development_report_detail.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_result_state.dart';

class KpspResultCubit extends Cubit<KpspResultState> {
  KpspResultCubit({required this.getReportDetail}) : super(KpspResultInitial());

  final GetChildDevelopmentReportDetail getReportDetail;

  Future<void> loadDetail(String reportId) async {
    emit(KpspResultLoading());
    final result = await getReportDetail(reportId);
    result.fold(
      (failure) => emit(KpspResultError(failure.message)),
      (detail) => emit(KpspResultLoaded(detail)),
    );
  }
}
