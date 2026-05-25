import 'dart:convert';
import 'package:flutter/foundation.dart';

class JwtUtils {
  /// Decode custom claim `https://api.nusagizi.com/roles` dari Access Token (JWT)
  /// Mengembalikan role pertama (String) jika ada, atau string kosong jika tidak ada.
  static String decodeRole(String accessToken) {
    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) return '';

      // Bagian payload adalah index ke-1
      String payload = parts[1];

      // Tambah padding Base64 jika perlu
      final remainder = payload.length % 4;
      if (remainder != 0) payload += '=' * (4 - remainder);

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> claims = jsonDecode(decoded);

      // Ambil custom claim yang diset Auth0 Post-Login Action
      final roles = claims['https://api.nusagizi.com/roles'] as List?;
      return roles?.first?.toString() ?? '';
    } catch (e) {
      debugPrint('[JwtUtils] Error decoding JWT: $e');
      return '';
    }
  }

  /// Cek apakah token mengandung role (sudah onboarding)
  static bool hasRole(String accessToken) {
    return decodeRole(accessToken).isNotEmpty;
  }
}
