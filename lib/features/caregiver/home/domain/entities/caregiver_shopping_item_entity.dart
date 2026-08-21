import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/caregiver_substitute_item_entity.dart';

class CaregiverShoppingItemEntity extends Equatable {
  final String name;
  final String unit;
  final int priority;
  final String slot;
  final String recipeId;
  final String childName;
  final List<CaregiverSubstituteItemEntity> substitutes;
  final bool isChecked;

  const CaregiverShoppingItemEntity({
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
