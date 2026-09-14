import 'package:equatable/equatable.dart';

abstract class EditChildPhotoState extends Equatable {
  const EditChildPhotoState();

  @override
  List<Object?> get props => [];
}

class EditChildPhotoInitial extends EditChildPhotoState {}

class EditChildPhotoLoading extends EditChildPhotoState {}

class EditChildPhotoSuccess extends EditChildPhotoState {}

class EditChildPhotoError extends EditChildPhotoState {
  final String message;

  const EditChildPhotoError({required this.message});

  @override
  List<Object?> get props => [message];
}
