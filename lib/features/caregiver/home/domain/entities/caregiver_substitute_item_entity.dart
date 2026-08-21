import 'package:equatable/equatable.dart';

class CaregiverSubstituteItemEntity extends Equatable {
  final String name;
  final String unit;
  final int priority;
  final String slot;

  const CaregiverSubstituteItemEntity({
    required this.name,
    required this.unit,
    required this.priority,
    required this.slot,
  });

  @override
  List<Object?> get props => [name, unit, priority, slot];
}
