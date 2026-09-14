import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/datasources/mother_profile_service.dart';
import 'package:nusagizi/features/mother/profile/data/models/checkin_token_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/mother_profile_repository.dart';

class MotherProfileRepositoryImpl implements MotherProfileRepository {
  final MotherProfileService service;

  MotherProfileRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, CheckinTokenModel>> generateCheckinToken(
    String childId,
  ) async {
    try {
      final result = await service.generateCheckinToken(childId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
