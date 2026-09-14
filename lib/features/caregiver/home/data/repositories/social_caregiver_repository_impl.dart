import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/home/data/datasources/social_caregiver_remote_datasource.dart';
import 'package:nusagizi/features/caregiver/home/data/models/create_caregiver_child_photo_request_model.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/social_caregiver_repository.dart';

class SocialCaregiverRepositoryImpl implements SocialCaregiverRepository {
  final SocialCaregiverRemoteDataSource remoteDataSource;

  SocialCaregiverRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createCaregiverChildPhoto(
    CreateCaregiverChildPhotoRequestModel request,
  ) async {
    try {
      final String id = await remoteDataSource.createCaregiverChildPhoto(
        request,
      );
      return Right(id);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return Left(
          ServerFailure(
            message: e.response!.data['message'] ?? 'Terjadi kesalahan server',
          ),
        );
      }
      return Left(const ServerFailure(message: 'Connection error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
