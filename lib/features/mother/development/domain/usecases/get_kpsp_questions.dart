import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/features/mother/development/domain/repositories/child_development_repository.dart';

class GetKpspQuestions implements UseCase<List<KpspQuestion>, int> {
  const GetKpspQuestions(this._repository);

  final ChildDevelopmentRepository _repository;

  @override
  Future<Either<Failure, List<KpspQuestion>>> call(int monthTarget) {
    return _repository.getKpspQuestions(monthTarget: monthTarget);
  }
}