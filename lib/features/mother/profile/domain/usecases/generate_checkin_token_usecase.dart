import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/profile/data/models/checkin_token_model.dart';
import 'package:nusagizi/features/mother/profile/domain/repositories/mother_profile_repository.dart';

class GenerateCheckinTokenUseCase implements UseCase<CheckinTokenModel, String> {
  final MotherProfileRepository repository;

  GenerateCheckinTokenUseCase({required this.repository});

  @override
  Future<Either<Failure, CheckinTokenModel>> call(String params) {
    return repository.generateCheckinToken(params);
  }
}
