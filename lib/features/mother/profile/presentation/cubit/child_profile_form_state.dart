part of 'child_profile_form_cubit.dart';

abstract class ChildProfileFormState {}

class ChildProfileFormInitial extends ChildProfileFormState {}

class ChildProfileFormLoading extends ChildProfileFormState {}

class ChildProfileFormSuccess extends ChildProfileFormState {
  final String childId;

  ChildProfileFormSuccess({required this.childId});
}

class ChildProfileFormFailure extends ChildProfileFormState {
  final String message;

  ChildProfileFormFailure({required this.message});
}

class ChildProfileFormDeleteSuccess extends ChildProfileFormState {
  final String childId;

  ChildProfileFormDeleteSuccess({required this.childId});
}
