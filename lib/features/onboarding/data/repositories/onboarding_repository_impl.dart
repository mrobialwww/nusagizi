import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/onboarding/data/datasources/onboarding_local_service.dart';
import 'package:nusagizi/features/onboarding/data/datasources/onboarding_service.dart';
import 'package:nusagizi/features/onboarding/data/models/onboarding_model.dart';
import 'package:nusagizi/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingService remoteDataSource;
  final OnboardingLocalService localDataSource;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> submitRole(String role) async {
    try {
      final model = OnboardingModel(role: role);

      // Simpan ke DB + assign role ke Auth0 via backend
      await remoteDataSource.submitOnboarding(model);

      // Paksa refresh token agar JWT baru (dengan claim roles) tersimpan lokal.
      try {
        await remoteDataSource.refreshToken();
      } catch (refreshError) {
        debugPrint(
          '[OnboardingRepositoryImpl] refreshToken gagal (diabaikan): $refreshError',
        );
      }

      // Simpan role secara lokal sebagai cadangan
      await localDataSource.cacheSelectedRole(role);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
