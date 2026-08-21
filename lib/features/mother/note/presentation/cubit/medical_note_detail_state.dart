import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';

abstract class MedicalNoteDetailState extends Equatable {
  const MedicalNoteDetailState();

  @override
  List<Object?> get props => [];
}

class MedicalNoteDetailInitial extends MedicalNoteDetailState {}

class MedicalNoteDetailLoading extends MedicalNoteDetailState {}

class MedicalNoteDetailSuccess extends MedicalNoteDetailState {
  final MedicalNoteDetailEntity detail;

  const MedicalNoteDetailSuccess({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class MedicalNoteDetailError extends MedicalNoteDetailState {
  final String message;

  const MedicalNoteDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
