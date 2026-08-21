import 'package:dio/dio.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/utils/date_helper.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/daily_menu_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/nutrition_report_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/nutrition_today_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/recipe_detail_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/recipe_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/shopping_item_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/swap_ingredient_request_model.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';

abstract class ChildNutritionService {
  Future<List<NutritionReportModel>> getNutritionReports(
    String childId,
    int month,
    int year,
  );

  Future<DailyMenuModel> getReportMenuById(String childId, String reportId);

  Future<RecipeDetailModel> getRecipeDetail(String recipeId);

  Future<NutritionTodayModel> getNutritionToday(String childId, DateTime date);

  Future<bool> updateBookmarkRecipe(String recipeId, bool isBookmarked);

  Future<void> updateRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  );

  Future<List<RecipeModel>> getBookmarkedRecipes(String childId);

  Future<List<ShoppingItemEntity>> getDailyShop(DateTime date);

  Future<void> swapIngredient(List<SwapIngredientRequestModel> requests);

  Future<void> generateMenu(DateTime date);

  Future<void> reuseRecipe(
    String childId,
    String sourceRecipeId,
    DateTime date,
  );
}

class ChildNutritionServiceImpl implements ChildNutritionService {
  final Dio dio;

  ChildNutritionServiceImpl({required this.dio});

  @override
  Future<List<NutritionReportModel>> getNutritionReports(
    String childId,
    int month,
    int year,
  ) async {
    try {
      final response = await dio.get(
        '/children/$childId/nutrition-reports',
        queryParameters: {'month': month, 'year': year},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data
            .map(
              (e) => NutritionReportModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw const ServerException(message: 'Failed to get nutrition reports');
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
  Future<DailyMenuModel> getReportMenuById(
    String childId,
    String reportId,
  ) async {
    try {
      final response = await dio.get(
        '/children/$childId/nutrition-reports/$reportId',
      );

      if (response.statusCode == 200) {
        return DailyMenuModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException(message: 'Failed to get report menu');
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
  Future<RecipeDetailModel> getRecipeDetail(String recipeId) async {
    try {
      final response = await dio.get('/recipes/$recipeId');

      if (response.statusCode == 200) {
        return RecipeDetailModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw const ServerException(message: 'Failed to get recipe detail');
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
  Future<NutritionTodayModel> getNutritionToday(
    String childId,
    DateTime date,
  ) async {
    try {
      final response = await dio.get(
        '/children/$childId/nutrition/today',
        queryParameters: {'date': DateHelper.toApiDate(date)},
      );

      if (response.statusCode == 200) {
        return NutritionTodayModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw const ServerException(message: 'Failed to get nutrition today');
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
  Future<bool> updateBookmarkRecipe(String recipeId, bool isBookmarked) async {
    try {
      await dio.patch(
        '/recipes/$recipeId/bookmark',
        data: {'is_bookmarked': isBookmarked},
      );

      return isBookmarked;
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
  Future<void> updateRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  ) async {
    try {
      await dio.patch(
        '/recipes/$recipeId/complete',
        data: {
          'portions_consumed': portionsConsumed,
          'report_date': DateHelper.toApiDate(date),
        },
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

  @override
  Future<List<RecipeModel>> getBookmarkedRecipes(String childId) async {
    try {
      final response = await dio.get('/children/$childId/recipes/bookmarked');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data
            .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw const ServerException(
          message: 'Failed to get bookmarked recipes',
        );
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
  Future<List<ShoppingItemEntity>> getDailyShop(DateTime date) async {
    try {
      final response = await dio.get(
        '/menu/daily-shop',
        queryParameters: {'date': DateHelper.toApiDate(date)},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map(
              (json) =>
                  ShoppingItemModel.fromJson(json as Map<String, dynamic>),
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
  Future<void> swapIngredient(List<SwapIngredientRequestModel> requests) async {
    try {
      await dio.patch(
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

  @override
  Future<void> generateMenu(DateTime date) async {
    try {
      final response = await dio.post(
        '/menu/generate',
        data: {'report_date': DateHelper.toApiDate(date)},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const ServerException(message: 'Gagal merakit menu baru');
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
  Future<void> reuseRecipe(
    String childId,
    String sourceRecipeId,
    DateTime date,
  ) async {
    try {
      final response = await dio.post(
        '/children/$childId/nutrition/reuse-recipe',
        data: {
          'source_recipe_id': sourceRecipeId,
          'report_date': DateHelper.toApiDate(date),
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const ServerException(message: 'Gagal menggunakan resep ini');
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
}
