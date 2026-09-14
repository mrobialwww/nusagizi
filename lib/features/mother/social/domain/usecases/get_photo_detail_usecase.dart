import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class GetPhotoDetailUseCase implements UseCase<ChildPhotoEntity, String> {
  final SocialRepository repository;

  GetPhotoDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, ChildPhotoEntity>> call(String params) {
    return repository.getPhotoDetail(params);
  }
}
