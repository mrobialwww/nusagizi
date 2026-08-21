import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/exceptions.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/features/caregiver/home/data/datasources/caregiver_home_service.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/repositories/caregiver_home_repository.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/recipe_detail_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_shopping_item_entity.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_swap_ingredient_request_entity.dart';
import 'package:nusagizi/features/caregiver/home/data/models/caregiver_swap_ingredient_request_model.dart';

class CaregiverHomeRepositoryImpl implements CaregiverHomeRepository {
  final CaregiverHomeService service;

  CaregiverHomeRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, ChildPreviewEntity>> fetchChildPreview(
    String childId,
  ) async {
    try {
      final result = await service.fetchChildPreview(childId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitCheckin(String token) async {
    try {
      final result = await service.submitCheckin(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CaregiverTodayMenuEntity>>
  getTodayMenuWithShoppingList(String childId, String date) async {
    try {
      final result = await service.getTodayMenuWithShoppingList(childId, date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildHeaderEntity>>> getChildrenSummary() async {
    try {
      final result = await service.getChildrenSummary();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeDetailEntity>> fetchCaregiverRecipeDetail(
    String recipeId,
  ) async {
    try {
      final result = await service.fetchCaregiverRecipeDetail(recipeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCaregiverRecipeCompletion(
    String recipeId,
    double portionsConsumed,
    DateTime date,
  ) async {
    try {
      final formattedDate = date.toIso8601String().split('T').first;
      await service.updateCaregiverRecipeCompletion(
        recipeId,
        portionsConsumed,
        formattedDate,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CaregiverShoppingItemEntity>>>
  getCaregiverDailyShop(String childId, DateTime date) async {
    try {
      final result = await service.getCaregiverDailyShop(date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> swapCaregiverIngredient(
    List<CaregiverSwapIngredientRequestEntity> requests,
  ) async {
    try {
      final modelRequests = requests
          .map(
            (r) => CaregiverSwapIngredientRequestModel(
              recipeId: r.recipeId,
              slot: r.slot,
              priority: r.priority,
            ),
          )
          .toList();
      await service.swapCaregiverIngredient(modelRequests);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
