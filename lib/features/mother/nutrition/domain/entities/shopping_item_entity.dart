import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/substitute_item_entity.dart';

class ShoppingItemEntity extends Equatable {
  final String name;
  final String unit;
  final int priority;
  final String slot;
  final String recipeId;
  final String childName;
  final List<SubstituteItemEntity> substitutes;
  final bool isChecked;

  const ShoppingItemEntity({
    required this.name,
    required this.unit,
    required this.priority,
    required this.slot,
    required this.recipeId,
    required this.childName,
    required this.substitutes,
    this.isChecked = false,
  });

  @override
  List<Object?> get props => [
    name,
    unit,
    priority,
    slot,
    recipeId,
    childName,
    substitutes,
    isChecked,
  ];
}
