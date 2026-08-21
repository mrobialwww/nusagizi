import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/social_caregiver_repository.dart';
import 'package:nusagizi/features/caregiver/home/data/models/create_caregiver_child_photo_request_model.dart';

class CreateCaregiverChildPhotoUseCase
    implements UseCase<String, CreateCaregiverChildPhotoRequestModel> {
  final SocialCaregiverRepository repository;

  CreateCaregiverChildPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    CreateCaregiverChildPhotoRequestModel params,
  ) async {
    return await repository.createCaregiverChildPhoto(params);
  }
}
