import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/profile/data/models/update_user_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/data/models/user_profile_model.dart';

abstract class UserProfileService {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateUserProfile(UpdateUserProfileRequestModel data);
}

class UserProfileServiceImpl implements UserProfileService {
  final Dio _dio;

  UserProfileServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Gagal mengambil data profil');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['error']?['message'] ?? e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserProfile(UpdateUserProfileRequestModel data) async {
    try {
      final response = await _dio.patch('/users', data: data.toJson());
      if (response.statusCode != 200) {
        throw ServerException(message: 'Gagal memperbarui profil');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['error']?['message'] ?? e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
