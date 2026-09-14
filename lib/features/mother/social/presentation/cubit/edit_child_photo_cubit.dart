import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/data/models/edit_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/domain/usecases/edit_child_photo_usecase.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/edit_child_photo_state.dart';

class EditChildPhotoCubit extends Cubit<EditChildPhotoState> {
  final EditChildPhotoUseCase editChildPhotoUseCase;

  EditChildPhotoCubit({required this.editChildPhotoUseCase})
    : super(EditChildPhotoInitial());

  Future<void> submitEdit(EditChildPhotoRequestModel request) async {
    emit(EditChildPhotoLoading());

    final result = await editChildPhotoUseCase(request);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(EditChildPhotoError(message: failure.message));
        }
      },
      (_) {
        if (!isClosed) emit(EditChildPhotoSuccess());
      },
    );
  }
}
