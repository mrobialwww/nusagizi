import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/home/domain/usecases/get_caregiver_recipe_detail_usecase.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_recipe_detail_state.dart';

class CaregiverRecipeDetailCubit extends Cubit<CaregiverRecipeDetailState> {
  final GetCaregiverRecipeDetailUseCase getCaregiverRecipeDetailUseCase;

  CaregiverRecipeDetailCubit({required this.getCaregiverRecipeDetailUseCase})
    : super(CaregiverRecipeDetailInitial());

  Future<void> fetchRecipeDetail(String recipeId) async {
    emit(CaregiverRecipeDetailLoading());
    final result = await getCaregiverRecipeDetailUseCase(recipeId);
    result.fold(
      (failure) => emit(CaregiverRecipeDetailError(message: failure.message)),
      (detail) => emit(CaregiverRecipeDetailLoaded(recipeDetail: detail)),
    );
  }
}
