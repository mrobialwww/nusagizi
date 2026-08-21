import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_today_menu_entity.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/daily_menu_model.dart';
import 'package:nusagizi/features/mother/nutrition/data/models/nutrition_today_shopping_item_model.dart';

class CaregiverTodayMenuModel extends CaregiverTodayMenuEntity {
  const CaregiverTodayMenuModel({super.menu, required super.shoppingList});

  factory CaregiverTodayMenuModel.fromJson(Map<String, dynamic> json) {
    return CaregiverTodayMenuModel(
      menu: json['menu'] != null
          ? DailyMenuModel.fromJson(json['menu'] as Map<String, dynamic>)
          : null,
      shoppingList:
          (json['shopping_list'] as List<dynamic>?)
              ?.map(
                (e) => NutritionTodayShoppingItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (menu != null) 'menu': (menu as DailyMenuModel).toJson(),
      'shopping_list': shoppingList
          .map((e) => (e as NutritionTodayShoppingItemModel).toJson())
          .toList(),
    };
  }
}
