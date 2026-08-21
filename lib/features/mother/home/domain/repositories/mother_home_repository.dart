import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';

abstract class MotherHomeRepository {
  Future<Either<Failure, List<ChildSummaryEntity>>> getChildrenSummary();
}
