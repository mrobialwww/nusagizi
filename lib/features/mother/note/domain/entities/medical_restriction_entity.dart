import 'package:equatable/equatable.dart';

class MedicalRestrictionEntity extends Equatable {
  final String id;
  final String type;
  final String restrictionName;

  const MedicalRestrictionEntity({
    required this.id,
    required this.type,
    required this.restrictionName,
  });

  @override
  List<Object?> get props => [id, type, restrictionName];
}
