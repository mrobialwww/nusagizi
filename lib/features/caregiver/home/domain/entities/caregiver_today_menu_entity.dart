import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/daily_menu_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/nutrition_today_entity.dart';

class CaregiverTodayMenuEntity extends Equatable {
  final DailyMenuEntity? menu;
  final List<NutritionTodayShoppingItem> shoppingList;

  const CaregiverTodayMenuEntity({this.menu, required this.shoppingList});

  @override
  List<Object?> get props => [menu, shoppingList];
}
