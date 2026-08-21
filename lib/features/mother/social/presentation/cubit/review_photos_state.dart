import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';

abstract class ReviewPhotosState extends Equatable {
  const ReviewPhotosState();

  @override
  List<Object> get props => [];
}

class ReviewPhotosInitial extends ReviewPhotosState {}

class ReviewPhotosLoading extends ReviewPhotosState {}

class ReviewPhotosLoaded extends ReviewPhotosState {
  final List<ChildPhotoEntity> photos;
  const ReviewPhotosLoaded(this.photos);

  @override
  List<Object> get props => [photos];
}

class ReviewPhotosError extends ReviewPhotosState {
  final String message;
  const ReviewPhotosError(this.message);

  @override
  List<Object> get props => [message];
}
