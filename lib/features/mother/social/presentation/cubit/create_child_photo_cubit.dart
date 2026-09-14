import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/services/image_upload/domain/usecases/upload_image_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/create_child_photo_usecase.dart';
import 'package:nusagizi/features/mother/social/data/models/create_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/create_child_photo_state.dart';

class CreateChildPhotoCubit extends Cubit<CreateChildPhotoState> {
  final UploadImageUseCase uploadImageUseCase;
  final CreateChildPhotoUseCase createChildPhotoUseCase;

  CreateChildPhotoCubit({
    required this.uploadImageUseCase,
    required this.createChildPhotoUseCase,
  }) : super(CreateChildPhotoInitial());

  Future<void> submitPhoto({
    required File imageFile,
    required String childId,
    required String caption,
    required String visibility,
    List<String>? listVisibility,
    bool isReviewRequired = false,
  }) async {
    emit(CreateChildPhotoLoading());

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
        emit(CreateChildPhotoFailure(failure.message));
      },
      (objectKey) async {
        // Step 2: Post to API
        final createResult = await createChildPhotoUseCase(
          CreateChildPhotoRequestModel(
            childId: childId,
            url: objectKey,
            caption: caption,
            visibility: visibility,
            listVisibility: listVisibility,
            isReviewRequired: isReviewRequired,
          ),
        );

        createResult.fold(
          (failure) => emit(CreateChildPhotoFailure(failure.message)),
          (id) => emit(CreateChildPhotoSuccess(id)),
        );
      },
    );
  }
}
