import 'package:dartz/dartz.dart';

import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class GetCaregiverTodayMenuUseCase
    implements UseCase<CaregiverTodayMenuEntity, String> {
  final CaregiverHomeRepository repository;

  GetCaregiverTodayMenuUseCase({required this.repository});

  @override
  Future<Either<Failure, CaregiverTodayMenuEntity>> call(String childId) async {
    final todayStr = DateTime.now().toIso8601String().split('T').first;
    return await repository.getTodayMenuWithShoppingList(childId, todayStr);
  }
}
