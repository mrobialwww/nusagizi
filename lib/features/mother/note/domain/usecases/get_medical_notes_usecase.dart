import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';

class GetMedicalNotesUseCase {
  final NoteRepository repository;

  GetMedicalNotesUseCase({required this.repository});

  Future<Either<Failure, List<MedicalNoteEntity>>> call({
    required String status,
    int? month,
    String? childName,
  }) {
    return repository.getMedicalNotes(
      status: status,
      month: month,
      childName: childName,
    );
  }
}
