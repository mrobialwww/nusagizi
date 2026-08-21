import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_own_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/review_photos_state.dart';
export 'package:nusagizi/features/mother/social/presentation/cubit/review_photos_state.dart';

class ReviewPhotosCubit extends Cubit<ReviewPhotosState> {
  final GetOwnChildPhotosUseCase getOwnChildPhotosUseCase;
  ReviewPhotosCubit(this.getOwnChildPhotosUseCase)
    : super(ReviewPhotosInitial());

  Future<void> fetchPendingReviewPhotos() async {
    emit(ReviewPhotosLoading());
    final result = await getOwnChildPhotosUseCase();
    result.fold((failure) => emit(ReviewPhotosError(failure.message)), (
      photos,
    ) {
      final pendingPhotos = photos.where((p) => p.isReviewRequired).toList();
      emit(ReviewPhotosLoaded(pendingPhotos));
    });
  }
}
