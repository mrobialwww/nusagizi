import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class GetCaregiverDailyShopUseCase
    implements UseCase<List<CaregiverShoppingItemEntity>, String> {
  final CaregiverHomeRepository repository;

  GetCaregiverDailyShopUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CaregiverShoppingItemEntity>>> call(
    String params,
  ) async {
    return await repository.getCaregiverDailyShop(params, DateTime.now());
  }
}
