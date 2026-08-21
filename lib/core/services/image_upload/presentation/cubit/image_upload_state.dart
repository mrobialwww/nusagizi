import 'package:equatable/equatable.dart';

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object> get props => [];
}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadInProgress extends ImageUploadState {
  final double progress; // 0.0 - 1.0

  const ImageUploadInProgress({required this.progress});

  @override
  List<Object> get props => [progress];
}

class ImageUploadSuccess extends ImageUploadState {
  final String objectKey;

  const ImageUploadSuccess({required this.objectKey});

  @override
  List<Object> get props => [objectKey];
}

class ImageUploadError extends ImageUploadState {
  final String message;

  const ImageUploadError({required this.message});

  @override
  List<Object> get props => [message];
}
