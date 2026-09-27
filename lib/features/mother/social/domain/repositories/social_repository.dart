import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/social/domain/entities/contact_entity.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/features/mother/social/data/models/create_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/data/models/review_child_photo_request_model.dart';

abstract class SocialRepository {
  Future<Either<Failure, List<ContactEntity>>> getContacts();
  Future<Either<Failure, void>> deleteContact(String contactId);
  Future<Either<Failure, List<ChildPhotoEntity>>> getOwnChildPhotos([
    String? childId,
  ]);
  Future<Either<Failure, List<ChildPhotoEntity>>> getContactChildPhotos(
    String contactId,
  );
  Future<Either<Failure, List<ChildPhotoEntity>>> getAllChildPhotos();
  Future<Either<Failure, ChildPhotoEntity>> getPhotoDetail(String childPhotoId);
  Future<Either<Failure, String>> createChildPhoto(
    CreateChildPhotoRequestModel request,
  );
  Future<Either<Failure, void>> reviewChildPhoto(
    ReviewChildPhotoRequestModel request,
  );
}
