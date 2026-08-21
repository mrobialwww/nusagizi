import 'package:equatable/equatable.dart';

class ShoppingChildItemEntity extends Equatable {
  final String childName;
  final String amount;
  final String colorHex;
  final String initial;

  const ShoppingChildItemEntity({
    required this.childName,
    required this.amount,
    required this.colorHex,
    required this.initial,
  });

  @override
  List<Object?> get props => [childName, amount, colorHex, initial];
}
