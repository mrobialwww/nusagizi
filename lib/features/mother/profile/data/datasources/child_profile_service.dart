import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_model.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_model.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';

abstract class ChildProfileService {
  Future<List<ChildProfileModel>> getChildren();
  Future<ChildModel> getChildDetail(String childId);
  Future<String> addChildProfile(ChildProfileRequestModel data);
  Future<void> updateChildProfile(
    String childId,
    ChildProfileRequestModel data,
  );
  Future<void> deleteChildProfile(String childId);
}

class ChildProfileServiceImpl implements ChildProfileService {
  final Dio _dio;

  ChildProfileServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<String> addChildProfile(ChildProfileRequestModel data) async {
    try {
      final response = await _dio.post('/children', data: data.toJson());

      if (response.statusCode == 201) {
        return response.data['id'] as String;
      } else {
        throw ServerException(
          message: 'Failed to add child profile: ${response.statusCode}',
        );
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
  Future<void> updateChildProfile(
    String childId,
    ChildProfileRequestModel data,
  ) async {
    try {
      final response = await _dio.patch(
        '/children/$childId',
        data: data.toJson(),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to update child profile: ${response.statusCode}',
        );
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
  Future<List<ChildProfileModel>> getChildren() async {
    try {
      final response = await _dio.get('/children');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ChildProfileModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal mengambil data anak');
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
  Future<void> deleteChildProfile(String childId) async {
    try {
      final response = await _dio.delete('/children/$childId');

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to delete child profile: ${response.statusCode}',
        );
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
  Future<ChildModel> getChildDetail(String childId) async {
    try {
      final response = await _dio.get('/children/$childId/profile');
      if (response.statusCode == 200) {
        return ChildModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Gagal mengambil detail profil anak');
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
