import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';

abstract class ChildProfileState extends Equatable {
  const ChildProfileState();

  @override
  List<Object> get props => [];
}

class ChildProfileInitial extends ChildProfileState {}

class ChildProfileLoading extends ChildProfileState {}

class ChildProfileLoaded extends ChildProfileState {
  final List<ChildProfileEntity> children;

  const ChildProfileLoaded(this.children);

  @override
  List<Object> get props => [children];
}

class ChildProfileError extends ChildProfileState {
  final String message;

  const ChildProfileError(this.message);

  @override
  List<Object> get props => [message];
}
