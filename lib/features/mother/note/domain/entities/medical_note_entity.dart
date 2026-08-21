import 'package:equatable/equatable.dart';

class MedicalNoteEntity extends Equatable {
  final String id;
  final DateTime validUntil;
  final String recommendation;
  final DateTime createdAt;
  final String childName;
  final int prohibitionCount;
  final int allergyCount;

  const MedicalNoteEntity({
    required this.id,
    required this.validUntil,
    required this.recommendation,
    required this.createdAt,
    required this.childName,
    required this.prohibitionCount,
    required this.allergyCount,
  });

  @override
  List<Object> get props => [
        id,
        validUntil,
        recommendation,
        createdAt,
        childName,
        prohibitionCount,
        allergyCount,
      ];
}
