import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/growth/data/datasources/child_growth_service.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_analyses_usecase.dart';

class GrowthRepositoryImpl implements GrowthRepository {
  final ChildGrowthService service;

  GrowthRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, LatestGrowthReportEntity>> getLatestGrowthReport(
    String childId,
  ) async {
    try {
      final remoteData = await service.getLatestGrowthReport(childId);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LatestGrowthReportEntity>>> getGrowthHistory(
    String childId,
  ) async {
    try {
      final remoteData = await service.getGrowthHistory(childId);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addGrowthReport(
    AddGrowthReportModel params,
  ) async {
    try {
      final id = await service.addGrowthReport(params);
      return Right(id);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GrowthAnalysesEntity>> getGrowthAnalyses(
    GrowthAnalysesParams params,
  ) async {
    try {
      final result = await service.getGrowthAnalyses(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
