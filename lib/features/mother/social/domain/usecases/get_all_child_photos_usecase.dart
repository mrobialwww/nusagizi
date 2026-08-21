import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class GetAllChildPhotosUseCase
    implements UseCaseNoParams<List<ChildPhotoEntity>> {
  final SocialRepository repository;

  GetAllChildPhotosUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChildPhotoEntity>>> call() {
    return repository.getAllChildPhotos();
  }
}
