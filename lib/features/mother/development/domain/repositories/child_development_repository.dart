import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';

abstract class ChildDevelopmentRepository {
  Future<Either<Failure, ChildDevelopmentSummaryEntity>>
  getChildDevelopmentSummary({required String childId});

  Future<Either<Failure, List<ChildDevelopmentHistoryEntity>>>
  getDevelopmentHistory({required String childId});

  Future<Either<Failure, ChildDevelopmentReportDetailEntity>>
  getDevelopmentReportDetail({required String reportId});

  Future<Either<Failure, List<KpspQuestion>>>
  getKpspQuestions({required int monthTarget});

  Future<Either<Failure, String>>
  createDevelopmentReport({
    required DevelopmentReportCreateRequestModel request,
  });

  Future<Either<Failure, String>>
  updateDevelopmentReport({
    required DevelopmentReportUpdateRequestModel request,
  });

  Future<Either<Failure, List<DevelopmentRecommendationEntity>>>
  getDevelopmentRecommendations({
    required String childId,
    required String reportId,
  });

  Future<Either<Failure, List<ChecklistMilestoneTaskEntity>>>
  getChecklistMilestoneTasks({
    required int monthTarget,
    required String childId,
  });

  Future<Either<Failure, void>>
  syncChecklistMilestoneProgress({
    required String childId,
    required List<String> assessmentKpspQuestionIds,
  });
}
