import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/note/domain/usecases/get_medical_note_detail_usecase.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_note_detail_state.dart';

class MedicalNoteDetailCubit extends Cubit<MedicalNoteDetailState> {
  final GetMedicalNoteDetailUseCase getMedicalNoteDetailUseCase;

  MedicalNoteDetailCubit({required this.getMedicalNoteDetailUseCase})
      : super(MedicalNoteDetailInitial());

  Future<void> fetchMedicalNoteDetail(String id) async {
    emit(MedicalNoteDetailLoading());

    final result = await getMedicalNoteDetailUseCase(id);

    result.fold(
      (failure) => emit(MedicalNoteDetailError(message: failure.message)),
      (detail) => emit(MedicalNoteDetailSuccess(detail: detail)),
    );
  }
}
