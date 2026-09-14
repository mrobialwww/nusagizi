import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_swap_ingredient_request_entity.dart';

class SwapCaregiverIngredientUseCase
    implements UseCase<void, List<CaregiverSwapIngredientRequestEntity>> {
  final CaregiverHomeRepository repository;

  SwapCaregiverIngredientUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
    List<CaregiverSwapIngredientRequestEntity> params,
  ) async {
    return await repository.swapCaregiverIngredient(params);
  }
}
