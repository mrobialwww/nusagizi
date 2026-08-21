import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';

class FetchChildPreviewUseCase implements UseCase<ChildPreviewEntity, String> {
  final CaregiverHomeRepository repository;

  FetchChildPreviewUseCase({required this.repository});

  @override
  Future<Either<Failure, ChildPreviewEntity>> call(String params) {
    return repository.fetchChildPreview(params);
  }
}
