import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/data/models/review_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/review_child_photo_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/review_child_photo_state.dart';

class ReviewChildPhotoCubit extends Cubit<ReviewChildPhotoState> {
  final ReviewChildPhotoUseCase reviewChildPhotoUseCase;

  ReviewChildPhotoCubit({required this.reviewChildPhotoUseCase})
    : super(ReviewChildPhotoInitial());

  Future<void> submitEdit(ReviewChildPhotoRequestModel request) async {
    emit(ReviewChildPhotoLoading());

    final result = await reviewChildPhotoUseCase(request);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ReviewChildPhotoError(message: failure.message));
        }
      },
      (_) {
        if (!isClosed) emit(ReviewChildPhotoSuccess());
      },
    );
  }
}
