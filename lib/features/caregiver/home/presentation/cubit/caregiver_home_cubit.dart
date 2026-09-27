import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_children_summary_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_home_state.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/data/models/child_header_model.dart';

class CaregiverHomeCubit extends Cubit<CaregiverHomeState> {
  final GetCaregiverChildrenSummaryUseCase getChildrenSummaryUseCase;
  final CaregiverChildrenCacheCubit cacheCubit;

  CaregiverHomeCubit({
    required this.getChildrenSummaryUseCase,
    required this.cacheCubit,
  }) : super(CaregiverHomeInitial());

  Future<void> getChildrenSummary() async {
    emit(CaregiverHomeLoading());

    final result = await getChildrenSummaryUseCase();
    result.fold(
      (failure) => emit(CaregiverHomeError(message: failure.message)),
      (children) {
        final cacheData = children
            .map(
              (c) => ChildHeaderModel(
                id: c.id,
                name: c.name,
                age: c.age,
                imagePath: c.imagePath,
                gender: c.gender,
              ),
            )
            .toList();
        cacheCubit.save(cacheData); // Simpan ke cache
        emit(CaregiverHomeLoaded(children: children));
      },
    );
  }
}
