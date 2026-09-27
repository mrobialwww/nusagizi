import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/social/data/datasources/social_service.dart';
import 'package:nusagizi/features/mother/social/domain/entities/child_photo_entity.dart';
import 'package:nusagizi/features/mother/social/domain/entities/contact_entity.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';
import 'package:nusagizi/features/mother/social/data/models/create_child_photo_request_model.dart';
import 'package:nusagizi/features/mother/social/data/models/review_child_photo_request_model.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialService remoteDataSource;

  SocialRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts() async {
    try {
      final result = await remoteDataSource.getContacts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String contactId) async {
    try {
      await remoteDataSource.deleteContact(contactId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildPhotoEntity>>> getOwnChildPhotos([
    String? childId,
  ]) async {
    try {
      final result = await remoteDataSource.getOwnChildPhotos(childId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildPhotoEntity>>> getContactChildPhotos(
    String contactId,
  ) async {
    try {
      final result = await remoteDataSource.getContactChildPhotos(contactId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildPhotoEntity>>> getAllChildPhotos() async {
    try {
      final result = await remoteDataSource.getAllChildPhotos();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildPhotoEntity>> getPhotoDetail(
    String childPhotoId,
  ) async {
    try {
      final result = await remoteDataSource.getPhotoDetail(childPhotoId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createChildPhoto(
    CreateChildPhotoRequestModel request,
  ) async {
    try {
      final result = await remoteDataSource.createChildPhoto(request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reviewChildPhoto(
    ReviewChildPhotoRequestModel request,
  ) async {
    try {
      await remoteDataSource.reviewChildPhoto(
        request.childId,
        request.childPhotoId,
        request,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
