import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/services/image_upload/domain/usecases/upload_image_usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/create_caregiver_child_photo_usecase.dart';
import 'package:nusagizi/features/caregiver/home/data/models/create_caregiver_child_photo_request_model.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/create_caregiver_child_photo_state.dart';

class CreateCaregiverChildPhotoCubit
    extends Cubit<CreateCaregiverChildPhotoState> {
  final UploadImageUseCase uploadImageUseCase;
  final CreateCaregiverChildPhotoUseCase createCaregiverChildPhotoUseCase;

  CreateCaregiverChildPhotoCubit({
    required this.uploadImageUseCase,
    required this.createCaregiverChildPhotoUseCase,
  }) : super(CreateCaregiverChildPhotoInitial());

  Future<void> submitPhoto({
    required File imageFile,
    required String childId,
  }) async {
    emit(CreateCaregiverChildPhotoLoading());

    // Step 1: Upload image to R2
    final uploadResult = await uploadImageUseCase(
      UploadImageParams(
        file: imageFile,
        category: 'social',
        contentType: 'image/jpeg',
        ownerId: childId,
      ),
    );

    uploadResult.fold(
      (failure) {
        emit(CreateCaregiverChildPhotoFailure(failure.message));
      },
      (objectKey) async {
        // Step 2: Post to API
        final createResult = await createCaregiverChildPhotoUseCase(
          CreateCaregiverChildPhotoRequestModel(
            childId: childId,
            url: objectKey,
            isReviewRequired: true,
          ),
        );

        createResult.fold(
          (failure) => emit(CreateCaregiverChildPhotoFailure(failure.message)),
          (id) => emit(CreateCaregiverChildPhotoSuccess(id)),
        );
      },
    );
  }
}
