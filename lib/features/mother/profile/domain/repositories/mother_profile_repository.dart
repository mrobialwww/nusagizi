import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/profile/data/models/checkin_token_model.dart';

abstract class MotherProfileRepository {
  Future<Either<Failure, CheckinTokenModel>> generateCheckinToken(String childId);
}
