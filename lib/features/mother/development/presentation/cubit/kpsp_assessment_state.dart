import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';

abstract class KpspAssessmentState {
  const KpspAssessmentState();
}

class KpspAssessmentInitial extends KpspAssessmentState {
  const KpspAssessmentInitial();
}

class KpspAssessmentLoading extends KpspAssessmentState {
  const KpspAssessmentLoading();
}

class KpspAssessmentLoaded extends KpspAssessmentState {
  final List<KpspQuestion> questions;

  const KpspAssessmentLoaded(this.questions);
}

class KpspAssessmentSubmitting extends KpspAssessmentState {
  final List<KpspQuestion> questions;

  const KpspAssessmentSubmitting(this.questions);
}

class KpspAssessmentSubmitSuccess extends KpspAssessmentState {
  final String reportId;

  const KpspAssessmentSubmitSuccess(this.reportId);
}

class KpspAssessmentError extends KpspAssessmentState {
  final String message;
  final List<KpspQuestion>? questionsFallback;

  const KpspAssessmentError(this.message, {this.questionsFallback});
}
