import 'package:auth0_flutter/auth0_flutter.dart';

class AuthService {
  final auth0 = Auth0(
    'dev-msiihoq456653nie.au.auth0.com',
    'XVT3JuCPHYQFRDGqd7M5RvnIewChCENf',
  );

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

  Future<Credentials> login(String email, String password) async {
    try {
      final credentials = await auth0.api.login(
        usernameOrEmail: email,
        password: password,
        connectionOrRealm: 'Username-Password-Authentication',
      );

      // Store the credentials afterward
      await auth0.credentialsManager.storeCredentials(credentials);
      return credentials;
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }
}
