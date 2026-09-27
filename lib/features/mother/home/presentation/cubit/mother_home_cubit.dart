import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/usecases/get_children_summary_usecase.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_state.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/data/models/child_header_model.dart';

class MotherHomeCubit extends Cubit<MotherHomeState> {
  final GetChildrenSummaryUseCase getChildrenSummaryUseCase;
  final ChildrenCacheCubit cacheCubit;

  MotherHomeCubit({
    required this.getChildrenSummaryUseCase,
    required this.cacheCubit,
  }) : super(MotherHomeInitial());

  Future<void> getChildrenSummary() async {
    emit(MotherHomeLoading());

    final result = await getChildrenSummaryUseCase();
    result.fold((failure) => emit(MotherHomeError(message: failure.message)), (
      children,
    ) {
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
      emit(MotherHomeLoaded(children: children));
    });
  }
}
