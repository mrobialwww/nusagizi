import '../../domain/entities/child_profile.dart';

class ChildProfileModel extends ChildProfile {
  const ChildProfileModel({
    required super.name,
    required super.birthDate,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    return ChildProfileModel(
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}
