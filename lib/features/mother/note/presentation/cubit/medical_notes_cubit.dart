import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/get_medical_notes_usecase.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_notes_state.dart';

class MedicalNotesCubit extends Cubit<MedicalNotesState> {
  final GetMedicalNotesUseCase getMedicalNotesUseCase;

  MedicalNotesCubit({required this.getMedicalNotesUseCase})
    : super(MedicalNotesInitial());

  Future<void> fetchMedicalNotes({
    required String status,
    int? month,
    String? childName,
  }) async {
    emit(MedicalNotesLoading());

    final result = await getMedicalNotesUseCase(
      status: status,
      month: month,
      childName: childName,
    );

    result.fold(
      (failure) => emit(MedicalNotesError(message: failure.message)),
      (notes) => emit(MedicalNotesSuccess(notes: notes)),
    );
  }
}
