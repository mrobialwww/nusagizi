import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';

abstract class AuthService {
  Future<DatabaseUser> register(String email, String password, String username);
  Future<Credentials> login(String email, String password);
  Future<Credentials> googleLogin();
  Future<void> logout();
  Future<Credentials?> getCurrentUser();
}

class AuthServiceImpl implements AuthService {
  final Auth0 auth0;

  AuthServiceImpl({required this.auth0});

  @override
  Future<DatabaseUser> register(
    String email,
    String password,
    String username,
  ) async {
    final nameParts = username.trim().split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    try {
      final credentials = await auth0.api.signup(
        email: email,
        password: password,
        connection: 'Username-Password-Authentication',
        userMetadata: {'first_name': firstName, 'last_name': lastName},
      );
      return credentials;
    } catch (e) {
      throw Exception('Gagal login: $e');
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
        // offline_access diperlukan agar Auth0 mengembalikan refresh token.
        // Tanpa ini, credentialsManager tidak bisa memperbarui token
        // dan melempar error saat minTtl digunakan.
        scopes: {'openid', 'profile', 'email', 'offline_access'},
      );

      // Store the credentials afterward
      await auth0.credentialsManager.storeCredentials(credentials);
      return credentials;
    } catch (e) {
      debugPrint('Gagal login: $e');
      throw Exception('Gagal login: $e');
    }
  }

  @override
  Future<Credentials> googleLogin() async {
    try {
      final credentials = await auth0
          .webAuthentication(scheme: 'https')
          .login(
            audience: 'https://api.nusagizi.com',
            parameters: {'connection': 'google-oauth2'},
          );

      await auth0.credentialsManager.storeCredentials(credentials);
      return credentials;
    } catch (e) {
      debugPrint('Gagal login: $e');
      throw Exception('Gagal login: $e');
    }
  }

  // Future<void> createTodoWithDio(String title) async {
  //   // 1. Ambil credentials yang sudah tersimpan sebelumnya
  //   final credentials = await auth0.credentialsManager.credentials();
  //   final token = credentials.accessToken;
  //   debugPrint("Token yang akan dikirim: $token");
  //   final dio = Dio();
  //   try {
  //     // Memanggil API dengan cara lebih ringkas menggunakan Dio
  //     var response = await dio.post(
  //       'https://d610-114-5-222-116.ngrok-free.app/todo',
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer $token",
  //         },
  //       ),
  //       // Dio otomatis meng-handle konversi Map ke JSON String
  //       data: {"title": title, "completed": false},
  //     );
  //     debugPrint("Berhasil membuat Todo: ${response.data}");
  //   } on DioException catch (e) {
  //     debugPrint("Gagal membuat Todo");
  //     if (e.response != null) {
  //       debugPrint("Status code: ${e.response?.statusCode}");
  //       debugPrint("Response error: ${e.response?.data}");
  //     } else {
  //       debugPrint("Error koneksi: ${e.message}");
  //     }
  //     rethrow;
  //   }
  // }

  @override
  Future<void> logout() async {
    try {
      // 1. Hapus sesi browser Auth0
      await auth0.webAuthentication(scheme: 'https').logout();
      // 2. Hapus credentials yang tersimpan secara lokal
      await auth0.credentialsManager.clearCredentials();
    } catch (e) {
      debugPrint("Error saat logout: $e");
      throw Exception('Gagal logout: $e');
    }
  }

  @override
  Future<Credentials?> getCurrentUser() async {
    try {
      final hasCredentials = await auth0.credentialsManager
          .hasValidCredentials();
      if (!hasCredentials) {
        return null;
      }
      return await auth0.credentialsManager.credentials();
    } catch (e) {
      debugPrint("Error saat getCurrentUser: $e");
      return null;
    }
  }
}
