import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/services/image_upload/data/models/presign_upload_model.dart';

abstract class ImageApiService {
  Future<PresignUploadModel> presignUpload({
    required String category,
    required String contentType,
    String? ownerId,
    String? existingObjectKey,
  });
}

class ImageApiServiceImpl implements ImageApiService {
  final Dio dio;

  ImageApiServiceImpl({required this.dio});

  @override
  Future<PresignUploadModel> presignUpload({
    required String category,
    required String contentType,
    String? ownerId,
    String? existingObjectKey,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'category': category,
        'content_type': contentType,
      };

      if (ownerId != null) {
        final key = (category == 'social' || category == 'child-profile')
            ? 'child_id'
            : 'owner_id';
        requestData[key] = ownerId;
      }
      if (existingObjectKey != null) {
        requestData['object_key'] = existingObjectKey;
      }

      final response = await dio.post(
        '/images/presign-upload',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PresignUploadModel.fromJson(response.data);
      } else {
        final data = response.data;
        String? errorMessage;
        if (data is Map) {
          if (data['error'] is String) {
            errorMessage = data['error'];
          } else if (data['error'] is Map) {
            errorMessage = data['error']['message'];
          }
          errorMessage ??= data['message'];
        }
        throw ServerException(
          message: errorMessage ?? 'Unknown error occurred',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorMessage;
      if (data is Map) {
        if (data['error'] is String) {
          errorMessage = data['error'];
        } else if (data['error'] is Map) {
          errorMessage = data['error']['message'];
        }
        errorMessage ??= data['message'];
      }
      throw ServerException(
        message: errorMessage ?? e.message ?? 'Unknown error occurred',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
