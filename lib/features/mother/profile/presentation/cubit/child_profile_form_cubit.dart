import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/add_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/update_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/delete_child_profile_usecase.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/add_growth_report_usecase.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

part 'child_profile_form_state.dart';

class ChildProfileFormCubit extends Cubit<ChildProfileFormState> {
  final AddChildProfileUseCase addChildProfileUseCase;
  final UpdateChildProfileUseCase updateChildProfileUseCase;
  final DeleteChildProfileUseCase deleteChildProfileUseCase;
  final AddGrowthReportUseCase addGrowthReportUseCase;
  final ChildrenCacheCubit cacheCubit;

  ChildProfileFormCubit({
    required this.addChildProfileUseCase,
    required this.updateChildProfileUseCase,
    required this.deleteChildProfileUseCase,
    required this.addGrowthReportUseCase,
    required this.cacheCubit,
  }) : super(ChildProfileFormInitial());

  Future<void> submitProfile(
    ChildProfileRequestModel request, {
    double? weightKg,
    double? heightCm,
    double? headCircumferenceCm,
  }) async {
    emit(ChildProfileFormLoading());

    final result = await addChildProfileUseCase(request);

    result.fold(
      (failure) => emit(ChildProfileFormFailure(message: failure.message)),
      (childId) async {
        if (weightKg != null && heightCm != null) {
          final growthModel = AddGrowthReportModel(
            childId: childId,
            measuredAt: DateTime.now(),
            weightKg: weightKg,
            heightCm: heightCm,
            headCircumferenceCm: headCircumferenceCm,
          );
          final growthResult = await addGrowthReportUseCase(growthModel);
          growthResult.fold(
            (failure) =>
                emit(ChildProfileFormFailure(message: failure.message)),
            (_) {
              cacheCubit.refresh();
              emit(ChildProfileFormSuccess(childId: childId));
            },
          );
        } else {
          cacheCubit.refresh();
          emit(ChildProfileFormSuccess(childId: childId));
        }
      },
    );
  }

  Future<void> updateProfile(
    String childId,
    ChildProfileRequestModel request,
  ) async {
    emit(ChildProfileFormLoading());

    final result = await updateChildProfileUseCase(childId, request);

    result.fold(
      (failure) => emit(ChildProfileFormFailure(message: failure.message)),
      (_) {
        cacheCubit.refresh();
        emit(ChildProfileFormSuccess(childId: childId));
      },
    );
  }

  Future<void> deleteChildProfile(String childId) async {
    emit(ChildProfileFormLoading());

    final result = await deleteChildProfileUseCase(childId);

    result.fold(
      (failure) => emit(ChildProfileFormFailure(message: failure.message)),
      (_) {
        cacheCubit.refresh();
        emit(ChildProfileFormDeleteSuccess(childId: childId));
      },
    );
  }
}
