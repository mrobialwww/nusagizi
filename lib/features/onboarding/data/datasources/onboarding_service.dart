import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import '../models/onboarding_model.dart';

abstract class OnboardingService {
  Future<void> submitOnboarding(OnboardingModel data);
  Future<Credentials> refreshToken();
}

class OnboardingServiceImpl implements OnboardingService {
  final Auth0 auth0;
  final Dio _dio = Dio();
  final String baseUrl = 'https://d610-114-5-222-116.ngrok-free.app';

  OnboardingServiceImpl({required this.auth0});

  @override
  Future<void> submitOnboarding(OnboardingModel data) async {
    try {
      final credentials = await auth0.credentialsManager.credentials();
      final token = credentials.accessToken;

      final response = await _dio.post(
        '$baseUrl/onboarding',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        data: data.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const ServerException(message: 'Server error');
      }
    } catch (e) {
      debugPrint("Gagal onboarding remote: $e");
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Credentials> refreshToken() async {
    try {
      // Memaksa SDK untuk fetch token baru (minTtl: 86400 detik = 1 hari)
      return await auth0.credentialsManager.credentials(minTtl: 86400);
    } catch (e) {
      debugPrint("Gagal refreshToken: $e");
      throw ServerException(message: e.toString());
    }
  }
}
