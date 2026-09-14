import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/mother/profile/data/models/checkin_token_model.dart';

abstract class MotherProfileService {
  Future<CheckinTokenModel> generateCheckinToken(String childId);
}

class MotherProfileServiceImpl implements MotherProfileService {
  final Dio _dio;

  MotherProfileServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<CheckinTokenModel> generateCheckinToken(String childId) async {
    try {
      final res = await _dio.post(
        '/checkin/generate',
        data: {'childId': childId},
      );

      return CheckinTokenModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = (code == 404)
          ? 'Data anak tidak ditemukan.'
          : 'Gagal membuat QR Code. Silakan coba lagi.';
      throw ServerException(message: msg);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
