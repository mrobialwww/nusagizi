import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/home/data/models/create_caregiver_child_photo_request_model.dart';

abstract class SocialCaregiverRepository {
  Future<Either<Failure, String>> createCaregiverChildPhoto(
    CreateCaregiverChildPhotoRequestModel request,
  );
}
