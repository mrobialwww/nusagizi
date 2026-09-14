import 'package:nusagizi/features/mother/profile/domain/entities/child_entity.dart';

class ChildModel extends ChildEntity {
  const ChildModel({
    required super.id,
    required super.fullName,
    required super.birthDate,
    required super.gender,
    super.photoUrl,
    super.streakDays,
    super.allergies,
    super.chronicDiseases,
    super.diets,
    super.favoriteFoods,
    super.favoriteTextures,
    super.notes,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      photoUrl: json['photo_url'],
      streakDays: json['streak_days'] ?? 0,
      allergies: Map<String, List<String>>.from(
        (json['allergies'] as Map? ?? {}).map(
          (key, value) =>
              MapEntry(key.toString(), List<String>.from(value ?? [])),
        ),
      ),
      chronicDiseases: List<String>.from(json['chronic_diseases'] ?? []),
      diets: List<String>.from(json['diets'] ?? []),
      favoriteFoods: List<String>.from(json['favorite_foods'] ?? []),
      favoriteTextures: List<String>.from(json['favorite_textures'] ?? []),
      notes: json['notes'],
    );
  }
}
