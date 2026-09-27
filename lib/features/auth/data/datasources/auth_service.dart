import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nusagizi/core/error/exceptions.dart';

abstract class AuthService {
  Future<DatabaseUser> register(String email, String password, String username);
  Future<Credentials> login(String email, String password);
  Future<Credentials?> googleLogin();
  Future<void> logout();
  Future<Credentials?> getCurrentUser();

  // Sends an OTP code to the provided email via Auth0 Passwordless.
  Future<void> sendEmailVerificationOtp({required String email});

  // Verifies the OTP code to obtain an ID token as proof of email ownership.
  Future<Credentials> verifyEmailOwnership({
    required String email,
    required String otpCode,
  });

  // Sends the ID token to the backend to mark the user's email as verified.
  Future<void> confirmEmailWithBackend({required String idToken});
}

class AuthServiceImpl implements AuthService {
  final Auth0 auth0;
  final Dio dio;

  AuthServiceImpl({required this.auth0, required this.dio});

  @override
  Future<DatabaseUser> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final credentials = await auth0.api.signup(
        email: email,
        password: password,
        connection: 'Username-Password-Authentication',
        // Save 'username' directly for Auth0 Post Login Action
        userMetadata: {'username': username},
      );
      return credentials;
    } on ApiException catch (e) {
      throw ServerException(message: _mapApiError(e));
    } catch (e) {
      throw ServerException(message: 'Registrasi gagal: $e');
    }
  }

  @override
  Future<Credentials> login(String email, String password) async {
    try {
      final credentials = await auth0.api.login(
        usernameOrEmail: email,
        password: password,
        connectionOrRealm: 'Username-Password-Authentication',
        audience: 'https://api.nusagizi.com',
        // 'offline_access' is required to get a refresh token
        scopes: {'openid', 'profile', 'email', 'offline_access'},
      );

      await auth0.credentialsManager.storeCredentials(credentials);
      return credentials;
    } on ApiException catch (e) {
      throw ServerException(message: _mapApiError(e));
    } catch (e) {
      throw ServerException(message: 'Login gagal: $e');
    }
  }

  @override
  Future<Credentials?> googleLogin() async {
    try {
      final credentials = await auth0
          .webAuthentication(scheme: 'com.nexuskesehatanina.nusagizi')
          .login(
            audience: 'https://api.nusagizi.com',
            scopes: {'openid', 'profile', 'email', 'offline_access'},
            parameters: {'connection': 'google-oauth2'},
          );

      await auth0.credentialsManager.storeCredentials(credentials);
      return credentials;
    } on WebAuthenticationException catch (e) {
      // User menekan back/close — abaikan tanpa error
      if (e.code == 'a0.authentication_canceled' ||
          e.details.toString().toLowerCase().contains('cancel') ||
          e.details.toString().toLowerCase().contains('dismiss')) {
        return null;
      }
      throw ServerException(message: e.details.toString());
    } on ApiException catch (e) {
      throw ServerException(message: _mapApiError(e));
    } catch (e) {
      throw ServerException(message: 'Google login gagal: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth0
          .webAuthentication(scheme: 'com.nexuskesehatanina.nusagizi')
          .logout();
    } catch (e) {
      throw ServerException(message: 'Logout gagal: $e');
    }
  }

  @override
  Future<Credentials?> getCurrentUser() async {
    try {
      final hasCredentials = await auth0.credentialsManager
          .hasValidCredentials();
      if (!hasCredentials) return null;
      return await auth0.credentialsManager.credentials();
    } catch (e) {
      debugPrint("Error in getCurrentUser: $e");
      return null;
    }
  }

  @override
  Future<void> sendEmailVerificationOtp({required String email}) async {
    try {
      await auth0.api.startPasswordlessWithEmail(
        email: email,
        passwordlessType: PasswordlessType.code,
      );
    } on ApiException catch (e) {
      throw ServerException(message: _mapApiError(e));
    } catch (e) {
      throw ServerException(message: 'Gagal mengirim OTP: $e');
    }
  }

  @override
  Future<Credentials> verifyEmailOwnership({
    required String email,
    required String otpCode,
  }) async {
    try {
      return await auth0.api.loginWithEmailCode(
        email: email,
        verificationCode: otpCode,
      );
    } on ApiException catch (e) {
      throw ServerException(message: _mapApiError(e));
    } catch (e) {
      throw ServerException(message: 'Verifikasi OTP gagal: $e');
    }
  }

  @override
  Future<void> confirmEmailWithBackend({required String idToken}) async {
    try {
      await dio.post('/confirm-email', data: {'id_token': idToken});
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to confirm email: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to confirm email: $e');
    }
  }

  String _mapApiError(ApiException e) {
    if (e.isTooManyAttempts) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }
    if (e.isInvalidCredentials) return 'Kode OTP salah atau sudah kedaluwarsa.';
    if (e.isNetworkError) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
    }
    return e.message.isNotEmpty ? e.message : 'Terjadi kesalahan, coba lagi.';
  }
}
