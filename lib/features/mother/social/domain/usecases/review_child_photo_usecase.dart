import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/data/models/review_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class ReviewChildPhotoUseCase
    implements UseCase<void, ReviewChildPhotoRequestModel> {
  final SocialRepository repository;

  ReviewChildPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReviewChildPhotoRequestModel params) {
    return repository.reviewChildPhoto(params);
  }
}
