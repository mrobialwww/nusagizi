import 'package:nusagizi/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalService {
  Future<void> cacheSelectedRole(String role);
}

class OnboardingLocalServiceImpl implements OnboardingLocalService {
  final SharedPreferences sharedPreferences;

  OnboardingLocalServiceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSelectedRole(String role) async {
    try {
      await sharedPreferences.setString('cached_role', role);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
