import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/data/models/update_user_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UserProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(UserProfileInitial());

  Future<void> loadProfile() async {
    emit(UserProfileLoading());
    final result = await getUserProfileUseCase();
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(UpdateUserProfileRequestModel request) async {
    emit(UserProfileUpdateLoading());
    final result = await updateUserProfileUseCase(request);
    result.fold(
      (failure) => emit(UserProfileUpdateError(failure.message)),
      (_) => emit(UserProfileUpdateSuccess()),
    );
  }
}
