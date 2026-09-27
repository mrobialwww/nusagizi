import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/services/image_upload/data/datasources/image_api_service.dart';
import 'package:nusagizi/core/services/image_upload/data/datasources/image_storage_service.dart';
import 'package:nusagizi/core/services/image_upload/domain/entities/presign_upload_entity.dart';
import 'package:nusagizi/core/services/image_upload/domain/repositories/image_upload_repository.dart';

class ImageUploadRepositoryImpl implements ImageUploadRepository {
  final ImageApiService apiService;
  final ImageStorageService storageService;

  ImageUploadRepositoryImpl({
    required this.apiService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, PresignUploadEntity>> requestPresignUrl({
    required String category,
    required String contentType,
    String? ownerId,
    String? existingObjectKey,
  }) async {
    try {
      final result = await apiService.presignUpload(
        category: category,
        contentType: contentType,
        ownerId: ownerId,
        existingObjectKey: existingObjectKey,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> putFileToStorage({
    required String uploadUrl,
    required File file,
    required String contentType,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      await storageService.putFile(
        uploadUrl: uploadUrl,
        file: file,
        contentType: contentType,
        onProgress: onProgress,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
