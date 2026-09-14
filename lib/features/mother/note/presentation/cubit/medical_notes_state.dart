import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';

abstract class MedicalNotesState extends Equatable {
  const MedicalNotesState();

  @override
  List<Object> get props => [];
}

class MedicalNotesInitial extends MedicalNotesState {}

class MedicalNotesLoading extends MedicalNotesState {}

class MedicalNotesSuccess extends MedicalNotesState {
  final List<MedicalNoteEntity> notes;

  const MedicalNotesSuccess({required this.notes});

  @override
  List<Object> get props => [notes];
}

class MedicalNotesError extends MedicalNotesState {
  final String message;

  const MedicalNotesError({required this.message});

  @override
  List<Object> get props => [message];
}
