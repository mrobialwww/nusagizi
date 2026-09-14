import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_kpsp_questions.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/submit_kpsp_assessment.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/update_kpsp_assessment.dart';
import 'kpsp_assessment_state.dart';

class KpspAssessmentCubit extends Cubit<KpspAssessmentState> {
  final GetKpspQuestions getKpspQuestions;
  final SubmitKpspAssessment submitKpspAssessment;
  final UpdateKpspAssessment updateKpspAssessment;

  KpspAssessmentCubit({
    required this.getKpspQuestions,
    required this.submitKpspAssessment,
    required this.updateKpspAssessment,
  }) : super(KpspAssessmentInitial());

  List<KpspQuestion> _currentQuestions = [];

  Future<void> loadQuestions(int monthTarget) async {
    emit(KpspAssessmentLoading());
    final result = await getKpspQuestions(monthTarget);
    result.fold(
      (failure) => emit(KpspAssessmentError(failure.message)),
      (questions) {
        _currentQuestions = questions;
        emit(KpspAssessmentLoaded(questions));
      },
    );
  }

  Future<void> submitAssessment({
    required DevelopmentReportCreateRequestModel request,
  }) async {
    if (request.listAnswer.length != _currentQuestions.length) {
      emit(
        KpspAssessmentError(
          'Semua pertanyaan harus dijawab',
          questionsFallback: _currentQuestions,
        ),
      );
      return;
    }

    emit(KpspAssessmentSubmitting(_currentQuestions));

    final result = await submitKpspAssessment(request);

    result.fold(
      (failure) => emit(
        KpspAssessmentError(
          failure.message,
          questionsFallback: _currentQuestions,
        ),
      ),
      (reportId) => emit(KpspAssessmentSubmitSuccess(reportId)),
    );
  }

  Future<void> retakeAssessment({
    required String childId,
    required String reportId,
    required List<KpspAnswerRequestModel> listAnswer,
  }) async {
    if (listAnswer.length != _currentQuestions.length) {
      emit(
        KpspAssessmentError(
          'Semua pertanyaan harus dijawab',
          questionsFallback: _currentQuestions,
        ),
      );
      return;
    }

    emit(KpspAssessmentSubmitting(_currentQuestions));

    final request = DevelopmentReportUpdateRequestModel(
      childId: childId,
      reportId: reportId,
      listAnswer: listAnswer,
    );
    final result = await updateKpspAssessment(request);

    result.fold(
      (failure) => emit(
        KpspAssessmentError(
          failure.message,
          questionsFallback: _currentQuestions,
        ),
      ),
      (reportId) => emit(KpspAssessmentSubmitSuccess(reportId)),
    );
  }
}
