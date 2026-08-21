import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:nusagizi/core/services/image_upload/domain/usecases/upload_image_usecase.dart';
import 'image_upload_state.dart';

class ImageUploadCubit extends Cubit<ImageUploadState> {
  final UploadImageUseCase uploadImageUseCase;

  ImageUploadCubit({required this.uploadImageUseCase})
    : super(ImageUploadInitial());

  Future<void> upload({
    required File file,
    required String category,
    String? ownerId,
  }) async {
    emit(const ImageUploadInProgress(progress: 0.0));

    final contentType = lookupMimeType(file.path) ?? 'application/octet-stream';

    final result = await uploadImageUseCase(
      UploadImageParams(
        file: file,
        category: category,
        contentType: contentType,
        ownerId: ownerId,
        onProgress: (sent, total) {
          if (total > 0 && !isClosed) {
            emit(ImageUploadInProgress(progress: sent / total));
          }
        },
      ),
    );

    if (!isClosed) {
      result.fold(
        (failure) => emit(ImageUploadError(message: failure.message)),
        (objectKey) => emit(ImageUploadSuccess(objectKey: objectKey)),
      );
    }
  }
}
