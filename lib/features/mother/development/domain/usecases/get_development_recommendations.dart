import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetDevelopmentRecommendations
    implements UseCase<List<DevelopmentRecommendationEntity>, ({String childId, String reportId})> {
  final ChildDevelopmentRepository repository;

  GetDevelopmentRecommendations(this.repository);

  @override
  Future<Either<Failure, List<DevelopmentRecommendationEntity>>> call(
    ({String childId, String reportId}) params,
  ) async {
    return await repository.getDevelopmentRecommendations(
      childId: params.childId,
      reportId: params.reportId,
    );
  }
}
