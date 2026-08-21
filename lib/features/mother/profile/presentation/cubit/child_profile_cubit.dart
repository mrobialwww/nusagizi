import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_children_usecase.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_state.dart';

class ChildProfileCubit extends Cubit<ChildProfileState> {
  final GetChildrenUseCase getChildrenUseCase;

  ChildProfileCubit({required this.getChildrenUseCase})
      : super(ChildProfileInitial());

  Future<void> loadChildren() async {
    emit(ChildProfileLoading());
    final result = await getChildrenUseCase();
    result.fold(
      (failure) => emit(ChildProfileError(failure.message)),
      (children) => emit(ChildProfileLoaded(children)),
    );
  }
}
