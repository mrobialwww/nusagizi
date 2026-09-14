import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/data/models/edit_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class EditChildPhotoUseCase
    implements UseCase<void, EditChildPhotoRequestModel> {
  final SocialRepository repository;

  EditChildPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EditChildPhotoRequestModel params) {
    return repository.editChildPhoto(params);
  }
}
