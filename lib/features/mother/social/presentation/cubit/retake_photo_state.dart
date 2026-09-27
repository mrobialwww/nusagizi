import 'package:equatable/equatable.dart';

abstract class RetakePhotoState extends Equatable {
  const RetakePhotoState();

  @override
  List<Object> get props => [];
}

class RetakePhotoInitial extends RetakePhotoState {}

class RetakePhotoLoading extends RetakePhotoState {}

class RetakePhotoSuccess extends RetakePhotoState {}

class RetakePhotoFailure extends RetakePhotoState {
  final String message;

  const RetakePhotoFailure(this.message);

  @override
  List<Object> get props => [message];
}
