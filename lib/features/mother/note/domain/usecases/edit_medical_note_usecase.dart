import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';

class EditMedicalNoteUseCase {
  final NoteRepository repository;

  EditMedicalNoteUseCase(this.repository);

  Future<Either<Failure, void>> call(String id, MedicalNoteRequestModel payload) {
    return repository.editMedicalNote(id, payload);
  }
}
