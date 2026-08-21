import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GenerateMenuUseCase implements UseCase<void, DateTime> {
  final NutritionRepository repository;

  GenerateMenuUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DateTime params) {
    return repository.generateMenu(params);
  }
}
