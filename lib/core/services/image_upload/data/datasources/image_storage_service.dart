import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import '../../domain/repositories/image_upload_repository.dart';

abstract class ImageStorageService {
  Future<void> putFile({
    required String uploadUrl,
    required File file,
    required String contentType,
    UploadProgressCallback? onProgress,
  });
}

class ImageStorageServiceImpl implements ImageStorageService {
  final Dio storageDio;

  ImageStorageServiceImpl({required this.storageDio});

  @override
  Future<void> putFile({
    required String uploadUrl,
    required File file,
    required String contentType,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      final fileLength = await file.length();

      final response = await storageDio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileLength,
            'Content-Type': contentType,
          },
        ),
        onSendProgress: onProgress,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: 'Failed to upload image to storage: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error occurred during upload',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
