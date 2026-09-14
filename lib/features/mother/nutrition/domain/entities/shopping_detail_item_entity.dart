import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_child_item_entity.dart';

class ShoppingDetailItemEntity extends Equatable {
  final String name;
  final String amount;
  final bool hasChildren;
  final List<ShoppingChildItemEntity>? children;
  final String? subtitle; // e.g. "untuk Razky"
  final String? originalParentName; // e.g. "Oat Instan"
  final String? childName; // e.g. "Razky"
  final bool isChecked;

  const ShoppingDetailItemEntity({
    required this.name,
    required this.amount,
    this.hasChildren = false,
    this.children,
    this.subtitle,
    this.originalParentName,
    this.childName,
    this.isChecked = false,
  });

  @override
  List<Object?> get props => [
    name,
    amount,
    hasChildren,
    children,
    subtitle,
    originalParentName,
    childName,
    isChecked,
  ];
}
