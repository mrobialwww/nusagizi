import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';

class GetMedicalNoteDetailUseCase
    implements UseCase<MedicalNoteDetailEntity, String> {
  final NoteRepository repository;

  GetMedicalNoteDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, MedicalNoteDetailEntity>> call(String params) {
    return repository.getMedicalNoteDetail(params);
  }
}
