import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/services/image_upload/domain/usecases/upload_image_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/retake_photo_state.dart';

class RetakePhotoCubit extends Cubit<RetakePhotoState> {
  final UploadImageUseCase uploadImageUseCase;

  RetakePhotoCubit({required this.uploadImageUseCase})
    : super(RetakePhotoInitial());

  Future<void> retake({
    required File imageFile,
    required String existingObjectKey,
  }) async {
    emit(RetakePhotoLoading());

    final uploadResult = await uploadImageUseCase(
      UploadImageParams(
        file: imageFile,
        category: 'social',
        contentType: 'image/jpeg',
        existingObjectKey: existingObjectKey,
      ),
    );

    uploadResult.fold(
      (failure) {
        emit(RetakePhotoFailure(failure.message));
      },
      (_) {
        emit(RetakePhotoSuccess());
      },
    );
  }
}
