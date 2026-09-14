import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_own_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_contact_child_photos_usecase.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/get_all_child_photos_usecase.dart';

import 'gallery_state.dart';
export 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final GetAllChildPhotosUseCase getAllChildPhotosUseCase;
  final GetOwnChildPhotosUseCase getOwnChildPhotosUseCase;
  final GetContactChildPhotosUseCase getContactChildPhotosUseCase;

  GalleryCubit({
    required this.getAllChildPhotosUseCase,
    required this.getOwnChildPhotosUseCase,
    required this.getContactChildPhotosUseCase,
  }) : super(GalleryInitial());

  Future<void> fetchAllPhotos() async {
    emit(GalleryLoading());
    final result = await getAllChildPhotosUseCase();
    result.fold(
      (failure) => emit(GalleryError(failure.message)),
      (photos) => emit(GalleryLoaded(photos)),
    );
  }

  Future<void> fetchOwnPhotos([String? childId]) async {
    emit(GalleryLoading());
    final result = await getOwnChildPhotosUseCase(childId);
    result.fold(
      (failure) => emit(GalleryError(failure.message)),
      (photos) => emit(GalleryLoaded(photos)),
    );
  }

  Future<void> fetchContactPhotos(String contactId, String contactName) async {
    emit(GalleryLoading());
    final result = await getContactChildPhotosUseCase(contactId);
    result.fold(
      (failure) => emit(GalleryError(failure.message)),
      (photos) => emit(GalleryLoaded(photos)),
    );
  }
}
