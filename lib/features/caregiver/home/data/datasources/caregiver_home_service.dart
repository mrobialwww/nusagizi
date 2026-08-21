import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/features/caregiver/home/data/models/child_preview_model.dart';
import 'package:nusagizi/features/caregiver/home/data/models/caregiver_today_menu_model.dart';
import 'package:nusagizi/features/mother/home/data/models/child_header_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/recipe_detail_model.dart';
import 'package:nusagizi/core/utils/date_helper.dart';
import 'package:nusagizi/features/caregiver/home/data/models/caregiver_shopping_item_model.dart';
import 'package:nusagizi/features/caregiver/home/data/models/caregiver_swap_ingredient_request_model.dart';

abstract class CaregiverHomeService {
  Future<ChildPreviewModel> fetchChildPreview(String childId);
  Future<bool> submitCheckin(String token);
  Future<CaregiverTodayMenuModel> getTodayMenuWithShoppingList(
    String childId,
    String date,
  );
  Future<List<ChildHeaderModel>> getChildrenSummary();
  Future<RecipeDetailModel> fetchCaregiverRecipeDetail(String recipeId);
  Future<void> updateCaregiverRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    String reportDate,
  );
  Future<List<CaregiverShoppingItemModel>> getCaregiverDailyShop(DateTime date);
  Future<void> swapCaregiverIngredient(
    List<CaregiverSwapIngredientRequestModel> requests,
  );
}

class CaregiverHomeServiceImpl implements CaregiverHomeService {
  final Dio _dio;

  CaregiverHomeServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ChildPreviewModel> fetchChildPreview(String childId) async {
    try {
      final res = await _dio.get('/children/$childId');
      return ChildPreviewModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(
          message: 'QR tidak dikenali atau anak tidak ditemukan 11.',
        );
      }
      throw const ServerException(
        message: 'Gagal mengambil data anak. Coba lagi 11.',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> submitCheckin(String token) async {
    try {
      final res = await _dio.post('/checkin/validate', data: {'token': token});

      final isNew = res.data['isNewEngagement'] as bool? ?? true;
      return isNew;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = (code == 403)
          ? 'QR sudah kedaluwarsa atau Anda belum memiliki profil caregiver.'
          : (code == 404)
          ? 'QR tidak dikenali atau anak tidak ditemukan.'
          : 'Tidak ada koneksi internet. Coba lagi.';

      throw ServerException(message: msg);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CaregiverTodayMenuModel> getTodayMenuWithShoppingList(
    String childId,
    String date,
  ) async {
    try {
      final res = await _dio.get(
        '/children/$childId/nutrition-reports/today/shopping',
        queryParameters: {'date': date},
      );
      return CaregiverTodayMenuModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404) {
        throw const ServerException(
          message: 'Data anak atau menu tidak ditemukan.',
        );
      }
      throw const ServerException(
        message: 'Gagal mengambil data menu hari ini.',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChildHeaderModel>> getChildrenSummary() async {
    try {
      final response = await _dio.get('/children');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => ChildHeaderModel.fromJson(json)).toList();
      } else {
        throw const ServerException(
          message: 'Gagal memuat data ringkasan anak',
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RecipeDetailModel> fetchCaregiverRecipeDetail(String recipeId) async {
    try {
      final res = await _dio.get('/recipes/$recipeId');
      return RecipeDetailModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Resep tidak ditemukan.');
      }
      throw const ServerException(message: 'Gagal memuat detail resep.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateCaregiverRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    String reportDate,
  ) async {
    try {
      await _dio.patch(
        '/recipes/$recipeId/complete',
        data: {
          'portions_consumed': portionsConsumed,
          'report_date': reportDate,
        },
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404) {
        throw const ServerException(message: 'Resep tidak ditemukan.');
      } else if (code == 403) {
        throw const ServerException(
          message: 'Resep ini bukan milik anak dari user yang login.',
        );
      }
      throw const ServerException(message: 'Gagal memperbarui status resep.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CaregiverShoppingItemModel>> getCaregiverDailyShop(
    DateTime date,
  ) async {
    try {
      final response = await _dio.get(
        '/menu/daily-shop',
        queryParameters: {'date': DateHelper.toApiDate(date)},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map(
              (json) => CaregiverShoppingItemModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      } else {
        throw const ServerException(message: 'Failed to get daily shop');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> swapCaregiverIngredient(
    List<CaregiverSwapIngredientRequestModel> requests,
  ) async {
    try {
      await _dio.patch(
        '/recipes/main-ingredients/priority',
        data: requests.map((r) => r.toJson()).toList(),
      );
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        try {
          message = e.response?.data['error']['message'] ?? message;
        } catch (_) {}
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
