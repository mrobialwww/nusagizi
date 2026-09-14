import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/fetch_child_preview_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/submit_checkin_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_qr_state.dart';

class CaregiverQRCubit extends Cubit<CaregiverQRState> {
  final FetchChildPreviewUseCase fetchChildPreviewUseCase;
  final SubmitCheckinUseCase submitCheckinUseCase;

  CaregiverQRCubit({
    required this.fetchChildPreviewUseCase,
    required this.submitCheckinUseCase,
  }) : super(CaregiverQRInitial());

  Future<void> fetchChildPreview(String token, String childId) async {
    emit(CaregiverQRLoading());

    final result = await fetchChildPreviewUseCase(childId);

    result.fold(
      (failure) => emit(CaregiverQRError(message: failure.message)),
      (data) => emit(CaregiverQRPreviewSuccess(data: data, token: token)),
    );
  }

  Future<void> submitCheckin(String token) async {
    emit(CaregiverQRLoading());

    final result = await submitCheckinUseCase(token);

    result.fold(
      (failure) => emit(
        CaregiverQRError(message: failure.message, isCheckinError: true),
      ),
      (isNewEngagement) =>
          emit(CaregiverQRCheckinSuccess(isNewEngagement: isNewEngagement)),
    );
  }
}
