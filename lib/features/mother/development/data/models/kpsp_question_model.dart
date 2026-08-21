import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';

class KpspQuestionModel extends KpspQuestion {
  const KpspQuestionModel({
    required super.id,
    required super.domain,
    required super.question,
    required super.monthTarget,
    super.imageUrl,
  });

  factory KpspQuestionModel.fromJson(Map<String, dynamic> json) {
    return KpspQuestionModel(
      id: json['id'] as String,
      domain: json['developmental_domain'] as String,
      question: json['question_text'] as String,
      monthTarget: json['month_target'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }
}
