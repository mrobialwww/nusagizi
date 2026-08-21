import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';
import 'package:nusagizi/features/mother/development/data/models/domain_score_model.dart';
import 'package:nusagizi/features/mother/development/data/models/recommended_action_model.dart';

class ChildDevelopmentReportDetailModel
    extends ChildDevelopmentReportDetailEntity {
  const ChildDevelopmentReportDetailModel({
    required super.id,
    required super.kpspScore,
    required super.monthTarget,
    required super.status,
    required super.kpspAnswersCount,
    required super.recommendedActions,
    required super.domains,
  });

  factory ChildDevelopmentReportDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChildDevelopmentReportDetailModel(
      id: json['id'] as String,
      kpspScore: json['kpsp_score'] as int,
      monthTarget: json['month_target'] as int,
      status: json['status'] as String,
      kpspAnswersCount: json['kpsp_answers_count'] as int,
      recommendedActions:
          (json['recommended_actions'] as List?)
              ?.map((e) => RecommendedActionModel.fromJson(e))
              .toList() ??
          [],
      domains:
          (json['domains'] as List?)
              ?.map((e) => DomainScoreModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
