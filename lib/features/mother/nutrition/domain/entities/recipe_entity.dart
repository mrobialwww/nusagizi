import 'package:equatable/equatable.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String name;
  final String mealTime;
  final String mealTexture;
  final double calories;
  final double protein;
  final double portionsConsumed;
  final String? imageUrl;

  const RecipeEntity({
    required this.id,
    required this.name,
    required this.mealTime,
    required this.mealTexture,
    required this.calories,
    required this.protein,
    required this.portionsConsumed,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    mealTime,
    mealTexture,
    calories,
    protein,
    portionsConsumed,
    imageUrl,
  ];
}
