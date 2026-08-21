import 'package:nusagizi/features/mother/development/domain/entities/domain_score_entity.dart';

class DomainScoreModel extends DomainScoreEntity {
  const DomainScoreModel({
    required super.developmentalDomain,
    required super.totalQuestion,
    required super.trueAnswer,
  });

  factory DomainScoreModel.fromJson(Map<String, dynamic> json) {
    return DomainScoreModel(
      developmentalDomain: json['developmental_domain'] as String,
      totalQuestion: json['total_question'] as int,
      trueAnswer: json['true_answer'] as int,
    );
  }
}
