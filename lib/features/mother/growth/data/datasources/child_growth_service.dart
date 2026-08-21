import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/growth/data/models/latest_growth_report_model.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';
import 'package:nusagizi/features/mother/growth/data/models/growth_analyses_model.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_analyses_usecase.dart';

abstract class ChildGrowthService {
  Future<LatestGrowthReportModel> getLatestGrowthReport(String childId);
  Future<List<LatestGrowthReportModel>> getGrowthHistory(String childId);
  Future<String> addGrowthReport(AddGrowthReportModel model);
  Future<GrowthAnalysesModel> getGrowthAnalyses(GrowthAnalysesParams params);
}

class ChildGrowthServiceImpl implements ChildGrowthService {
  final Dio dio;

  ChildGrowthServiceImpl({required this.dio});

  @override
  Future<LatestGrowthReportModel> getLatestGrowthReport(String childId) async {
    try {
      final response = await dio.get(
        '/children/$childId/growth-reports/latest',
      );

      if (response.statusCode == 200) {
        return LatestGrowthReportModel.fromJson(response.data);
      } else {
        throw const ServerException(
          message: 'Failed to get latest growth report',
        );
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LatestGrowthReportModel>> getGrowthHistory(String childId) async {
    try {
      final response = await dio.get('/children/$childId/growth-reports');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => LatestGrowthReportModel.fromJson(json))
            .toList();
      } else {
        throw const ServerException(message: 'Failed to get growth history');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> addGrowthReport(AddGrowthReportModel model) async {
    try {
      final data = model.toJson();

      final response = await dio.post(
        '/children/${model.childId}/growth-reports',
        data: data,
      );

      if (response.statusCode == 201) {
        return response.data['id'] as String;
      } else {
        throw const ServerException(
          message: 'Gagal menyimpan data pertumbuhan',
        );
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan saat menyimpan data';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<GrowthAnalysesModel> getGrowthAnalyses(
    GrowthAnalysesParams params,
  ) async {
    try {
      final response = await dio.get(
        '/children/${params.childId}/growth-analyses',
        queryParameters: {
          'analysis_type': params.analysisType,
          'age_range': params.ageRange,
        },
      );

      if (response.statusCode == 200) {
        return GrowthAnalysesModel.fromJson(response.data);
      } else {
        throw const ServerException(
          message: 'Gagal memuat analisis pertumbuhan',
        );
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response?.data != null) {
        try {
          message = e.response!.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
