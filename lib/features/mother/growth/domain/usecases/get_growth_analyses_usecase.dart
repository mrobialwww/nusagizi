import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/repositories/growth_repository.dart';

class GrowthAnalysesParams extends Equatable {
  final String childId;
  final String analysisType;
  final String ageRange;

  const GrowthAnalysesParams({
    required this.childId,
    required this.analysisType,
    required this.ageRange,
  });

  @override
  List<Object?> get props => [childId, analysisType, ageRange];
}

class GetGrowthAnalysesUseCase {
  final GrowthRepository repository;

  GetGrowthAnalysesUseCase(this.repository);

  Future<Either<Failure, GrowthAnalysesEntity>> call(
    GrowthAnalysesParams params,
  ) {
    return repository.getGrowthAnalyses(params);
  }
}
