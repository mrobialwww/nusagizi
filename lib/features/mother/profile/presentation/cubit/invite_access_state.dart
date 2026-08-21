import 'package:equatable/equatable.dart';

abstract class InviteAccessState extends Equatable {
  const InviteAccessState();

  @override
  List<Object?> get props => [];
}

class InviteAccessInitial extends InviteAccessState {}

class InviteAccessLoading extends InviteAccessState {}

class InviteAccessSuccess extends InviteAccessState {
  final String token;
  final DateTime expiresAt;

  const InviteAccessSuccess({
    required this.token,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [token, expiresAt];
}

class InviteAccessError extends InviteAccessState {
  final String message;

  const InviteAccessError({required this.message});

  @override
  List<Object?> get props => [message];
}
