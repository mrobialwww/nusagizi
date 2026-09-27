import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/development/data/datasources/child_development_service.dart';
import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';

class ChildDevelopmentRepositoryImpl implements ChildDevelopmentRepository {
  const ChildDevelopmentRepositoryImpl(this.service);

  final ChildDevelopmentService service;

  @override
  Future<Either<Failure, ChildDevelopmentSummaryEntity?>>
  getChildDevelopmentSummary({required String childId}) async {
    try {
      final model = await service.getReport(childId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildDevelopmentHistoryEntity>>>
  getDevelopmentHistory({required String childId}) async {
    try {
      final models = await service.getDevelopmentHistory(childId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildDevelopmentReportDetailEntity>>
  getDevelopmentReportDetail({required String reportId}) async {
    try {
      final model = await service.getDevelopmentReportDetail(reportId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KpspQuestion>>> getKpspQuestions({
    required int monthTarget,
  }) async {
    try {
      final models = await service.getKpspQuestions(monthTarget);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createDevelopmentReport({
    required DevelopmentReportCreateRequestModel request,
  }) async {
    try {
      final reportId = await service.createDevelopmentReport(request);
      return Right(reportId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateDevelopmentReport({
    required DevelopmentReportUpdateRequestModel request,
  }) async {
    try {
      final updatedReportId = await service.updateDevelopmentReport(request);
      return Right(updatedReportId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DevelopmentRecommendationEntity>>>
  getDevelopmentRecommendations({
    required String childId,
    required String reportId,
  }) async {
    try {
      final models = await service.getDevelopmentRecommendations(
        childId: childId,
        reportId: reportId,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChecklistMilestoneTaskEntity>>>
  getChecklistMilestoneTasks({
    required int monthTarget,
    required String childId,
  }) async {
    try {
      final models = await service.getChecklistMilestoneTasks(
        monthTarget: monthTarget,
        childId: childId,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncChecklistMilestoneProgress({
    required String childId,
    required List<String> assessmentKpspQuestionIds,
  }) async {
    try {
      await service.syncChecklistMilestoneProgress(
        childId: childId,
        assessmentKpspQuestionIds: assessmentKpspQuestionIds,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
