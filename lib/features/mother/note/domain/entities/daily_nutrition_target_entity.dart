import 'package:equatable/equatable.dart';

class DailyNutritionTargetEntity extends Equatable {
  final String id;
  final String nutrient;
  final double quantity;

  const DailyNutritionTargetEntity({
    required this.id,
    required this.nutrient,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, nutrient, quantity];
}
