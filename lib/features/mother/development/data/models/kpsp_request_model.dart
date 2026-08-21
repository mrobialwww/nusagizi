class KpspAnswerRequestModel {
  final String questionId;
  final bool answer;

  const KpspAnswerRequestModel({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'assessment_kpsp_question_id': questionId,
      'answer': answer,
    };
  }
}

class DevelopmentReportCreateRequestModel {
  final String childId;
  final int monthTarget;
  final List<KpspAnswerRequestModel> listAnswer;

  const DevelopmentReportCreateRequestModel({
    required this.childId,
    required this.monthTarget,
    required this.listAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'child_id': childId,
      'month_target': monthTarget,
      'list_answer': listAnswer.map((e) => e.toJson()).toList(),
    };
  }
}

class DevelopmentReportUpdateRequestModel {
  final String childId;
  final String reportId;
  final List<KpspAnswerRequestModel> listAnswer;

  const DevelopmentReportUpdateRequestModel({
    required this.childId,
    required this.reportId,
    required this.listAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'list_answer': listAnswer.map((e) => e.toJson()).toList(),
    };
  }
}