import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/services/image_upload/domain/entities/presign_upload_entity.dart';

typedef UploadProgressCallback = void Function(int sent, int total);

abstract class ImageUploadRepository {
  Future<Either<Failure, PresignUploadEntity>> requestPresignUrl({
    required String category,
    required String contentType,
    String? ownerId,
    String? existingObjectKey,
  });

  Future<Either<Failure, void>> putFileToStorage({
    required String uploadUrl,
    required File file,
    required String contentType,
    UploadProgressCallback? onProgress,
  });
}
