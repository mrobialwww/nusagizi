import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/core/services/image_upload/domain/repositories/image_upload_repository.dart';
import 'package:nusagizi/core/services/image_upload/domain/entities/presign_upload_entity.dart';

class UploadImageParams {
  final File file;
  final String category;
  final String contentType;
  final String? ownerId;
  final UploadProgressCallback? onProgress;

  const UploadImageParams({
    required this.file,
    required this.category,
    required this.contentType,
    this.ownerId,
    this.onProgress,
  });
}

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final ImageUploadRepository repository;

  UploadImageUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    final presignResult = await repository.requestPresignUrl(
      category: params.category,
      contentType: params.contentType,
      ownerId: params.ownerId,
    );

    return presignResult.fold((failure) async => Left(failure), (
      PresignUploadEntity presign,
    ) async {
      final putResult = await repository.putFileToStorage(
        uploadUrl: presign.uploadUrl,
        file: params.file,
        contentType: params.contentType,
        onProgress: params.onProgress,
      );

      return putResult.fold(
        (failure) => Left(failure),
        (_) => Right(presign.objectKey),
      );
    });
  }
}
