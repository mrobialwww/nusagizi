import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_photo_detail_usecase.dart';
import 'photo_detail_state.dart';
export 'photo_detail_state.dart';

class PhotoDetailCubit extends Cubit<PhotoDetailState> {
  final GetPhotoDetailUseCase getPhotoDetailUseCase;

  PhotoDetailCubit({required this.getPhotoDetailUseCase})
    : super(PhotoDetailInitial());

  Future<void> fetchDetail(String photoId) async {
    emit(PhotoDetailLoading());
    final result = await getPhotoDetailUseCase(photoId);
    result.fold(
      (failure) => emit(PhotoDetailError(failure.message)),
      (photo) => emit(PhotoDetailLoaded(photo)),
    );
  }
}
