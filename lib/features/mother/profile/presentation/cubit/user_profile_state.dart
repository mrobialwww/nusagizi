import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/user_profile_entity.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileEntity profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class UserProfileUpdateLoading extends UserProfileState {}

class UserProfileUpdateSuccess extends UserProfileState {}

class UserProfileUpdateError extends UserProfileState {
  final String message;

  const UserProfileUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
