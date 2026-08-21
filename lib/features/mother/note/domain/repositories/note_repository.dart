import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<MedicalNoteEntity>>> getMedicalNotes({
    required String status,
    int? month,
    String? childName,
  });

  Future<Either<Failure, MedicalNoteDetailEntity>> getMedicalNoteDetail(
    String id,
  );

  Future<Either<Failure, void>> addMedicalNote(MedicalNoteRequestModel payload);

  Future<Either<Failure, void>> editMedicalNote(
    String id,
    MedicalNoteRequestModel payload,
  );
}
