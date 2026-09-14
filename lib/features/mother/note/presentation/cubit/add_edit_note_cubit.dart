import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/add_medical_note_usecase.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/edit_medical_note_usecase.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/add_edit_note_state.dart';

class AddEditMedicalNoteCubit extends Cubit<AddEditMedicalNoteState> {
  final AddMedicalNoteUseCase addMedicalNoteUseCase;
  final EditMedicalNoteUseCase editMedicalNoteUseCase;

  AddEditMedicalNoteCubit({
    required this.addMedicalNoteUseCase,
    required this.editMedicalNoteUseCase,
  }) : super(AddEditMedicalNoteInitial());

  Future<void> addMedicalNote(MedicalNoteRequestModel payload) async {
    emit(AddEditMedicalNoteLoading());
    final result = await addMedicalNoteUseCase(payload);
    result.fold(
      (failure) => emit(AddEditMedicalNoteError(failure.message)),
      (_) => emit(AddEditMedicalNoteSuccess()),
    );
  }

  Future<void> editMedicalNote(String id, MedicalNoteRequestModel payload) async {
    emit(AddEditMedicalNoteLoading());
    final result = await editMedicalNoteUseCase(id, payload);
    result.fold(
      (failure) => emit(AddEditMedicalNoteError(failure.message)),
      (_) => emit(AddEditMedicalNoteSuccess()),
    );
  }
}
