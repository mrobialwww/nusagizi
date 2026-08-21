import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_swap_ingredient_request_entity.dart';

abstract class CaregiverHomeRepository {
  Future<Either<Failure, ChildPreviewEntity>> fetchChildPreview(String childId);
  Future<Either<Failure, bool>> submitCheckin(String token);
  Future<Either<Failure, CaregiverTodayMenuEntity>>
  getTodayMenuWithShoppingList(String childId, String date);
  Future<Either<Failure, List<ChildHeaderEntity>>> getChildrenSummary();
  Future<Either<Failure, RecipeDetailEntity>> fetchCaregiverRecipeDetail(
    String recipeId,
  );
  Future<Either<Failure, void>> updateCaregiverRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  );
  Future<Either<Failure, List<CaregiverShoppingItemEntity>>>
  getCaregiverDailyShop(String childId, DateTime date);
  Future<Either<Failure, void>> swapCaregiverIngredient(
    List<CaregiverSwapIngredientRequestEntity> requests,
  );
}
