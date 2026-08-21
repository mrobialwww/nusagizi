import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/home/data/datasources/mother_home_service.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/mother_home_repository.dart';

class MotherHomeRepositoryImpl implements MotherHomeRepository {
  final MotherHomeService service;

  MotherHomeRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<ChildSummaryEntity>>> getChildrenSummary() async {
    try {
      final models = await service.getChildrenSummary();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan tidak terduga'));
    }
  }
}
