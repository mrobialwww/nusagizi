import 'package:equatable/equatable.dart';

abstract class CreateCaregiverChildPhotoState extends Equatable {
  const CreateCaregiverChildPhotoState();

  @override
  List<Object> get props => [];
}

class CreateCaregiverChildPhotoInitial extends CreateCaregiverChildPhotoState {}

class CreateCaregiverChildPhotoLoading extends CreateCaregiverChildPhotoState {}

class CreateCaregiverChildPhotoSuccess extends CreateCaregiverChildPhotoState {
  final String id;
  const CreateCaregiverChildPhotoSuccess(this.id);

  @override
  List<Object> get props => [id];
}

class CreateCaregiverChildPhotoFailure extends CreateCaregiverChildPhotoState {
  final String message;
  const CreateCaregiverChildPhotoFailure(this.message);

  @override
  List<Object> get props => [message];
}
