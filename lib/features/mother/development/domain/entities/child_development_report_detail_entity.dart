import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/development/domain/entities/domain_score_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/recommended_action_entity.dart';

class ChildDevelopmentReportDetailEntity extends Equatable {
  final String id;
  final int kpspScore;
  final int monthTarget;
  final String status;
  final int kpspAnswersCount;
  final List<RecommendedActionEntity> recommendedActions;
  final List<DomainScoreEntity> domains;

  const ChildDevelopmentReportDetailEntity({
    required this.id,
    required this.kpspScore,
    required this.monthTarget,
    required this.status,
    required this.kpspAnswersCount,
    required this.recommendedActions,
    required this.domains,
  });

  @override
  List<Object?> get props => [
    id,
    kpspScore,
    monthTarget,
    status,
    kpspAnswersCount,
    recommendedActions,
    domains,
  ];
}
