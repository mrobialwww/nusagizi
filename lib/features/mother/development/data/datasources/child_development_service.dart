import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/development/data/models/checklist_milestone_task_model.dart';
import 'package:nusagizi/features/mother/development/data/models/child_development_summary_model.dart';
import 'package:nusagizi/features/mother/development/data/models/child_development_history_model.dart';
import 'package:nusagizi/features/mother/development/data/models/child_development_report_detail_model.dart';
import 'package:nusagizi/features/mother/development/data/models/development_recommendation_model.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_question_model.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';

abstract class ChildDevelopmentService {
  Future<ChildDevelopmentSummaryModel> getReport(String childId);
  Future<List<ChildDevelopmentHistoryModel>> getDevelopmentHistory(
    String childId,
  );
  Future<ChildDevelopmentReportDetailModel> getDevelopmentReportDetail(
    String reportId,
  );
  Future<List<KpspQuestionModel>> getKpspQuestions(int monthTarget);
  Future<String> createDevelopmentReport(
    DevelopmentReportCreateRequestModel request,
  );
  Future<String> updateDevelopmentReport(
    DevelopmentReportUpdateRequestModel request,
  );
  Future<List<DevelopmentRecommendationModel>> getDevelopmentRecommendations({
    required String childId,
    required String reportId,
  });

  Future<List<ChecklistMilestoneTaskModel>> getChecklistMilestoneTasks({
    required int monthTarget,
    required String childId,
  });

  Future<void> syncChecklistMilestoneProgress({
    required String childId,
    required List<String> assessmentKpspQuestionIds,
  });
}

class ChildDevelopmentServiceImpl implements ChildDevelopmentService {
  final Dio dio;
  const ChildDevelopmentServiceImpl({required this.dio});

  @override
  Future<ChildDevelopmentSummaryModel> getReport(String childId) async {
    try {
      final response = await dio.get(
        '/children/$childId/development-reports/latest',
      );
      return ChildDevelopmentSummaryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(
          message: 'Belum ada laporan KPSP sama sekali',
        );
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChildDevelopmentHistoryModel>> getDevelopmentHistory(
    String childId,
  ) async {
    try {
      final response = await dio.get('/children/$childId/development-reports');
      final List data = response.data as List;
      return data
          .map(
            (json) => ChildDevelopmentHistoryModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Data anak tidak ditemukan');
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChildDevelopmentReportDetailModel> getDevelopmentReportDetail(
    String reportId,
  ) async {
    try {
      final response = await dio.get('/development-reports/$reportId');
      return ChildDevelopmentReportDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Laporan KPSP tidak ditemukan');
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<KpspQuestionModel>> getKpspQuestions(int monthTarget) async {
    try {
      final response = await dio.get(
        '/assessment-kpsp-questions',
        queryParameters: {'month_target': monthTarget},
      );
      final List data = response.data as List;
      return data
          .map(
            (json) => KpspQuestionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Soal KPSP tidak ditemukan');
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> createDevelopmentReport(
    DevelopmentReportCreateRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        '/children/${request.childId}/development-reports',
        data: request.toJson(),
      );
      return response.data['id'] as String;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create report');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> updateDevelopmentReport(
    DevelopmentReportUpdateRequestModel request,
  ) async {
    try {
      final response = await dio.patch(
        '/children/${request.childId}/development-reports/${request.reportId}',
        data: request.toJson(),
      );
      return response.data['id'] as String;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update report');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DevelopmentRecommendationModel>> getDevelopmentRecommendations({
    required String childId,
    required String reportId,
  }) async {
    try {
      final response = await dio.get(
        '/children/$childId/development-reports/$reportId/recommendations',
      );
      final List data = response.data as List;
      return data
          .map(
            (json) => DevelopmentRecommendationModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Laporan KPSP tidak ditemukan');
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChecklistMilestoneTaskModel>> getChecklistMilestoneTasks({
    required int monthTarget,
    required String childId,
  }) async {
    try {
      final response = await dio.get(
        '/checklist-milestone-tasks',
        queryParameters: {'month_target': monthTarget, 'child_id': childId},
      );
      final List data = response.data as List;
      return data
          .map(
            (json) => ChecklistMilestoneTaskModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const ServerException(message: 'month_target invalid');
      }
      if (e.response?.statusCode == 403) {
        throw const ServerException(
          message: 'child_id bukan milik user yang login',
        );
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> syncChecklistMilestoneProgress({
    required String childId,
    required List<String> assessmentKpspQuestionIds,
  }) async {
    try {
      await dio.patch(
        '/children/$childId/checklist-milestone-progress',
        data: {'assessment_kpsp_question_ids': assessmentKpspQuestionIds},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const ServerException(
          message: 'child_id bukan milik user yang login',
        );
      }
      if (e.response?.statusCode == 404) {
        throw const ServerException(
          message: 'ada assessment_kpsp_question_id yang tidak ditemukan',
        );
      }
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
