import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/social/domain/entities/contact_entity.dart';
import 'package:nusagizi/features/mother/social/domain/repositories/social_repository.dart';

class GetContactsUseCase implements UseCaseNoParams<List<ContactEntity>> {
  final SocialRepository repository;

  GetContactsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ContactEntity>>> call() {
    return repository.getContacts();
  }
}
