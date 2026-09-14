import 'package:equatable/equatable.dart';

abstract class AddEditMedicalNoteState extends Equatable {
  const AddEditMedicalNoteState();

  @override
  List<Object?> get props => [];
}

class AddEditMedicalNoteInitial extends AddEditMedicalNoteState {}

class AddEditMedicalNoteLoading extends AddEditMedicalNoteState {}

class AddEditMedicalNoteSuccess extends AddEditMedicalNoteState {}

class AddEditMedicalNoteError extends AddEditMedicalNoteState {
  final String message;

  const AddEditMedicalNoteError(this.message);

  @override
  List<Object?> get props => [message];
}
