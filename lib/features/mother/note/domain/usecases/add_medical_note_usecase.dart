import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';

class AddMedicalNoteUseCase {
  final NoteRepository repository;

  AddMedicalNoteUseCase(this.repository);

  Future<Either<Failure, void>> call(MedicalNoteRequestModel payload) {
    return repository.addMedicalNote(payload);
  }
}
