import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';
import 'package:nusagizi/features/mother/nutrition/data/datasources/child_nutrition_service.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_report_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/swap_ingredient_request_entity.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/swap_ingredient_request_model.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  final ChildNutritionService service;

  NutritionRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<NutritionReportEntity>>> getNutritionReports(
    String childId,
    int month,
    int year,
  ) async {
    try {
      final reports = await service.getNutritionReports(childId, month, year);
      return Right(reports);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyMenuEntity>> getReportMenuById(
    String childId,
    String reportId,
  ) async {
    try {
      final menu = await service.getReportMenuById(childId, reportId);
      return Right(menu);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeDetailEntity>> getRecipeDetail(
    String recipeId,
  ) async {
    try {
      final detail = await service.getRecipeDetail(recipeId);
      return Right(detail);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionTodayEntity>> getNutritionToday(
    String childId,
    DateTime date,
  ) async {
    try {
      final result = await service.getNutritionToday(childId, date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBookmarkRecipe(
    String recipeId,
    bool isBookmarked,
  ) async {
    try {
      final result = await service.updateBookmarkRecipe(recipeId, isBookmarked);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getBookmarkedRecipes(
    String childId,
  ) async {
    try {
      final recipes = await service.getBookmarkedRecipes(childId);
      return Right(recipes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  ) async {
    try {
      await service.updateRecipeCompletion(recipeId, portionsConsumed, date);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShoppingItemEntity>>> getDailyShop(
    DateTime date,
  ) async {
    try {
      final items = await service.getDailyShop(date);
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> swapIngredient(
    List<SwapIngredientRequestEntity> requests,
  ) async {
    try {
      final modelRequests = requests
          .map(
            (r) => SwapIngredientRequestModel(
              recipeId: r.recipeId,
              slot: r.slot,
              priority: r.priority,
            ),
          )
          .toList();
      await service.swapIngredient(modelRequests);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> generateMenu(DateTime date) async {
    try {
      await service.generateMenu(date);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reuseRecipe(
    String childId,
    String sourceRecipeId,
    DateTime date,
  ) async {
    try {
      await service.reuseRecipe(childId, sourceRecipeId, date);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
