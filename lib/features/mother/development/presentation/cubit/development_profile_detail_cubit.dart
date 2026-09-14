import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/development/domain/usecases/get_development_recommendations.dart';
import 'development_profile_detail_state.dart';

class DevelopmentProfileDetailCubit
    extends Cubit<DevelopmentProfileDetailState> {
  final GetDevelopmentRecommendations getDevelopmentRecommendations;

  DevelopmentProfileDetailCubit({
    required this.getDevelopmentRecommendations,
  }) : super(DevelopmentProfileDetailInitial());

  Future<void> loadRecommendations({
    required String childId,
    required String reportId,
  }) async {
    emit(DevelopmentProfileDetailLoading());
    final result = await getDevelopmentRecommendations(
      (childId: childId, reportId: reportId),
    );
    result.fold(
      (failure) => emit(DevelopmentProfileDetailError(failure.message)),
      (recommendations) =>
          emit(DevelopmentProfileDetailLoaded(recommendations)),
    );
  }
}
