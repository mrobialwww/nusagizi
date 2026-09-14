import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';

abstract class PhotoDetailState extends Equatable {
  const PhotoDetailState();

  @override
  List<Object?> get props => [];
}

class PhotoDetailInitial extends PhotoDetailState {}

class PhotoDetailLoading extends PhotoDetailState {}

class PhotoDetailLoaded extends PhotoDetailState {
  final ChildPhotoEntity photo;
  const PhotoDetailLoaded(this.photo);

  @override
  List<Object?> get props => [photo];
}

class PhotoDetailError extends PhotoDetailState {
  final String message;
  const PhotoDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
