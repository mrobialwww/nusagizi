import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/note/data/datasources/note_service.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';
import 'package:nusagizi/features/mother/note/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteService service;

  NoteRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<MedicalNoteEntity>>> getMedicalNotes({
    required String status,
    int? month,
    String? childName,
  }) async {
    try {
      final models = await service.getMedicalNotes(
        status: status,
        month: month,
        childName: childName,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, MedicalNoteDetailEntity>> getMedicalNoteDetail(
    String id,
  ) async {
    try {
      final detail = await service.getMedicalNoteDetail(id);
      return Right(detail);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> addMedicalNote(
    MedicalNoteRequestModel payload,
  ) async {
    try {
      await service.addMedicalNote(payload.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> editMedicalNote(
    String id,
    MedicalNoteRequestModel payload,
  ) async {
    try {
      await service.editMedicalNote(id, payload.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }
}
