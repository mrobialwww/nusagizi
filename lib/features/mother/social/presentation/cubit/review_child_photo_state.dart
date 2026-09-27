import 'package:equatable/equatable.dart';

abstract class ReviewChildPhotoState extends Equatable {
  const ReviewChildPhotoState();

  @override
  List<Object?> get props => [];
}

class ReviewChildPhotoInitial extends ReviewChildPhotoState {}

class ReviewChildPhotoLoading extends ReviewChildPhotoState {}

class ReviewChildPhotoSuccess extends ReviewChildPhotoState {}

class ReviewChildPhotoError extends ReviewChildPhotoState {
  final String message;

  const ReviewChildPhotoError({required this.message});

  @override
  List<Object?> get props => [message];
}
