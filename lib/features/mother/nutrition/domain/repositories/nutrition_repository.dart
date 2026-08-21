import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/swap_ingredient_request_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_report_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';

abstract class NutritionRepository {
  Future<Either<Failure, List<NutritionReportEntity>>> getNutritionReports(
    String childId,
    int month,
    int year,
  );

  Future<Either<Failure, DailyMenuEntity>> getReportMenuById(
    String childId,
    String reportId,
  );

  Future<Either<Failure, RecipeDetailEntity>> getRecipeDetail(String recipeId);

  Future<Either<Failure, NutritionTodayEntity>> getNutritionToday(
    String childId,
    DateTime date,
  );

  Future<Either<Failure, bool>> updateBookmarkRecipe(
    String recipeId,
    bool isBookmarked,
  );

  Future<Either<Failure, void>> updateRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  );

  Future<Either<Failure, List<RecipeEntity>>> getBookmarkedRecipes(
    String childId,
  );

  Future<Either<Failure, List<ShoppingItemEntity>>> getDailyShop(DateTime date);

  Future<Either<Failure, void>> swapIngredient(
    List<SwapIngredientRequestEntity> requests,
  );

  Future<Either<Failure, void>> generateMenu(DateTime date);

  Future<Either<Failure, void>> reuseRecipe(
    String childId,
    String sourceRecipeId,
    DateTime date,
  );
}
