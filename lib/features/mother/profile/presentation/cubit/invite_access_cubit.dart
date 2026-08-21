import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/generate_checkin_token_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/invite_access_state.dart';

class InviteAccessCubit extends Cubit<InviteAccessState> {
  final GenerateCheckinTokenUseCase generateCheckinTokenUseCase;

  InviteAccessCubit({required this.generateCheckinTokenUseCase})
    : super(InviteAccessInitial());

  Future<void> generateToken(String childId) async {
    emit(InviteAccessLoading());

    final result = await generateCheckinTokenUseCase(childId);

    result.fold(
      (failure) => emit(InviteAccessError(message: failure.message)),
      (data) => emit(
        InviteAccessSuccess(token: data.token, expiresAt: data.expiresAt),
      ),
    );
  }
}
