import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class GetOwnChildPhotosUseCase {
  final SocialRepository repository;

  GetOwnChildPhotosUseCase({required this.repository});

  Future<Either<Failure, List<ChildPhotoEntity>>> call([String? childId]) {
    return repository.getOwnChildPhotos(childId);
  }
}
