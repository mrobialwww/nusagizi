import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';

class GetDailyShopUseCase
    implements UseCase<List<ShoppingItemEntity>, DateTime> {
  final NutritionRepository repository;

  GetDailyShopUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ShoppingItemEntity>>> call(
    DateTime params,
  ) async {
    return await repository.getDailyShop(params);
  }
}
