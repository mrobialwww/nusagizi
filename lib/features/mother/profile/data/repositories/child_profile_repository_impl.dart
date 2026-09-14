import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/child_profile_service.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/child_profile_repository.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_entity.dart';

class ChildProfileRepositoryImpl implements ChildProfileRepository {
  final ChildProfileService service;

  ChildProfileRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, String>> addChildProfile(
    ChildProfileRequestModel data,
  ) async {
    try {
      final childId = await service.addChildProfile(data);
      return Right(childId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateChildProfile(
    String childId,
    ChildProfileRequestModel data,
  ) async {
    try {
      await service.updateChildProfile(childId, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildProfileEntity>>> getChildren() async {
    try {
      final result = await service.getChildren();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildEntity>> getChildDetail(String childId) async {
    try {
      final result = await service.getChildDetail(childId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChildProfile(String childId) async {
    try {
      await service.deleteChildProfile(childId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
