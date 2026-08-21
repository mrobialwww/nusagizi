import 'package:equatable/equatable.dart';

abstract class MenuActionState extends Equatable {
  const MenuActionState();

  @override
  List<Object?> get props => [];
}

class MenuActionInitial extends MenuActionState {}

class MenuActionGenerateLoading extends MenuActionState {}

class MenuActionGenerateSuccess extends MenuActionState {}

class MenuActionReuseLoading extends MenuActionState {}

class MenuActionReuseSuccess extends MenuActionState {}

class MenuActionError extends MenuActionState {
  final String message;

  const MenuActionError(this.message);

  @override
  List<Object?> get props => [message];
}
