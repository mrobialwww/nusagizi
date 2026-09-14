import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/profile/data/models/caregiver_engagement_model.dart';

abstract class CaregiverEngagementService {
  Future<List<CaregiverEngagementModel>> getActiveEngagements();
  Future<List<CaregiverEngagementModel>> getRevokedEngagements();
  Future<void> revokeEngagement(String engagementId);
}

class CaregiverEngagementServiceImpl implements CaregiverEngagementService {
  final Dio dio;

  CaregiverEngagementServiceImpl({required this.dio});

  @override
  Future<List<CaregiverEngagementModel>> getActiveEngagements() async {
    try {
      final response = await dio.get('/mother-profiles/caregiver-engagements');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CaregiverEngagementModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal memuat data akses aktif');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CaregiverEngagementModel>> getRevokedEngagements() async {
    try {
      final response = await dio.get('/mother-profiles/caregiver-engagements/revoked');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CaregiverEngagementModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal memuat riwayat akses yang dicabut');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> revokeEngagement(String engagementId) async {
    try {
      final response = await dio.delete('/caregiver-engagements/$engagementId');
      if (response.statusCode != 200) {
        throw ServerException(message: 'Gagal mencabut akses pengasuh');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
