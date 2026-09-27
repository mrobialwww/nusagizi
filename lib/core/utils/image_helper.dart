import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';

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

  static AssetImage getDefaultChildImage(String gender) {
    if (gender.trim().toLowerCase() == 'female') {
      return const AssetImage(AppImages.defaultFemaleChildProfile);
    }
    return const AssetImage(AppImages.defaultMaleChildProfile);
  }

  static AssetImage getDefaultUserImage([String? gender]) {
    if (gender?.trim().toLowerCase() == 'male') {
      return const AssetImage(AppImages.defaultMaleUserProfile);
    }
    return const AssetImage(AppImages.defaultUserProfile);
  }

  static AssetImage getDefaultDailyCaptureImage(String gender) {
    if (gender.trim().toLowerCase() == 'female') {
      return const AssetImage(AppImages.defaultDailyFemaleCapture);
    }
    return const AssetImage(AppImages.defaultDailyMaleCapture);
  }
}
