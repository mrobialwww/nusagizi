import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/caregiver_profile_model.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';

abstract class CaregiverProfileService {
  Future<CaregiverProfileModel> getCaregiverProfile();
  Future<void> updateCaregiverProfile(UpdateCaregiverProfileRequestModel data);
}

class CaregiverProfileServiceImpl implements CaregiverProfileService {
  final Dio _dio;

  CaregiverProfileServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<CaregiverProfileModel> getCaregiverProfile() async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200) {
        return CaregiverProfileModel.fromJson(response.data);
      } else {
        throw const ServerException(message: 'Gagal mengambil data profil');
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateCaregiverProfile(
    UpdateCaregiverProfileRequestModel data,
  ) async {
    try {
      final response = await _dio.patch('/users', data: data.toJson());
      if (response.statusCode != 200) {
        throw const ServerException(message: 'Gagal memperbarui profil');
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
