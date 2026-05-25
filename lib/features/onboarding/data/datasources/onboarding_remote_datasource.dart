import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/onboarding_model.dart';

class OnboardingRemoteDataSource {
  final auth0 = Auth0(
    'dev-msiihoq456653nie.au.auth0.com',
    'XVT3JuCPHYQFRDGqd7M5RvnIewChCENf',
  );

  final Dio _dio = Dio();
  final String baseUrl = 'https://159f-103-189-201-74.ngrok-free.app';

  Future<void> submitOnboarding(OnboardingModel data) async {
    final credentials = await auth0.credentialsManager.credentials();
    final token = credentials.accessToken;

    try {
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
        throw Exception('Server mengembalikan status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Gagal onboarding: ${e.response?.data ?? e.message}");
      throw Exception('Gagal menyimpan profil: ${e.message}');
    }
  }

  Future<Credentials> refreshToken() async {
    // Memaksa SDK untuk fetch token baru karena minTtl sangat besar
    return await auth0.credentialsManager.credentials(minTtl: 999999);
  }
}
