import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';

abstract class OnboardingRepository {
  /// Mengirimkan role yang dipilih ke backend dan menyimpannya secara lokal
  Future<Either<Failure, void>> submitRole(String role);
}
