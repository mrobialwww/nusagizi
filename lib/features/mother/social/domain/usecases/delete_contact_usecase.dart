import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class DeleteContactUseCase implements UseCase<void, String> {
  final SocialRepository repository;

  DeleteContactUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteContact(params); // params is contactId
  }
}
