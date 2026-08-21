import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';
import 'package:nusagizi/features/mother/social/data/models/create_child_photo_request_model.dart';

class CreateChildPhotoUseCase
    implements UseCase<String, CreateChildPhotoRequestModel> {
  final SocialRepository repository;

  CreateChildPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    CreateChildPhotoRequestModel params,
  ) async {
    return await repository.createChildPhoto(params);
  }
}
