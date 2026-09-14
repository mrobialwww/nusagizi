import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<ChildPhotoEntity> photos;
  const GalleryLoaded(this.photos);

  @override
  List<Object?> get props => [photos];
}

class GalleryError extends GalleryState {
  final String message;
  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
