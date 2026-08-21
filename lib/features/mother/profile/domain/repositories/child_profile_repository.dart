import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_entity.dart';

abstract class ChildProfileRepository {
  Future<Either<Failure, String>> addChildProfile(
    ChildProfileRequestModel data,
  );
  Future<Either<Failure, void>> updateChildProfile(
    String childId,
    ChildProfileRequestModel data,
  );
  Future<Either<Failure, List<ChildProfileEntity>>> getChildren();
  Future<Either<Failure, ChildEntity>> getChildDetail(String childId);
  Future<Either<Failure, void>> deleteChildProfile(String childId);
}
