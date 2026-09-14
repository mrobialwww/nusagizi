import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageHelper {
  /// Gets a safe ImageProvider or null if the path is invalid or empty.
  /// If it returns null, you should display the user's initials.
  static ImageProvider? getSafeImageProvider(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImageProvider(
        path,
        errorListener: (err) =>
            debugPrint('CachedNetworkImage failed to load: $err'),
      );
    }

    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }

    // Likely an R2 object key missing its presigned URL domain.
    // Return null so the UI can fallback to initials.
    return null;
  }

  /// Gets up to 2 uppercase initials from a full name.
  static String getInitials(String name) {
    if (name.trim().isEmpty) return 'U';

    // Clean multiple spaces
    final cleanName = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    final parts = cleanName.split(' ');

    if (parts.length >= 2) {
      final firstChar = parts[0][0];
      final secondChar = parts[1][0];
      return '$firstChar$secondChar'.toUpperCase();
    }

    // If only one word, take up to the first two characters
    return name
        .trim()
        .substring(0, name.trim().length > 1 ? 2 : 1)
        .toUpperCase();
  }

  /// Generates a stable color from a given string (like a name).
  static Color getAvatarColor(String name) {
    if (name.trim().isEmpty) {
      return const Color(0xFF00A735); // Default primary green
    }

    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }

    // Generate HSL color for vibrant, readable avatar backgrounds
    // Saturation around 60%, Lightness around 40% (ensures white text is readable)
    final h = (hash % 360).abs().toDouble();
    return HSLColor.fromAHSL(1.0, h, 0.6, 0.4).toColor();
  }
}
