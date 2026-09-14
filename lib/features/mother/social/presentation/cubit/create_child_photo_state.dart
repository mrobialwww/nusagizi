import 'package:equatable/equatable.dart';

abstract class CreateChildPhotoState extends Equatable {
  const CreateChildPhotoState();

  @override
  List<Object> get props => [];
}

class CreateChildPhotoInitial extends CreateChildPhotoState {}

class CreateChildPhotoLoading extends CreateChildPhotoState {}

class CreateChildPhotoSuccess extends CreateChildPhotoState {
  final String childPhotoId;
  const CreateChildPhotoSuccess(this.childPhotoId);

  @override
  List<Object> get props => [childPhotoId];
}

class CreateChildPhotoFailure extends CreateChildPhotoState {
  final String message;
  const CreateChildPhotoFailure(this.message);

  @override
  List<Object> get props => [message];
}
