import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  final String id;
  final String fullName;
  final String birthDate;
  final String gender;
  final String? photoUrl;
  final int streakDays;
  final Map<String, List<String>> allergies;
  final List<String> chronicDiseases;
  final List<String> diets;
  final List<String> favoriteFoods;
  final List<String> favoriteTextures;
  final String? notes;

  const ChildEntity({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.gender,
    this.photoUrl,
    this.streakDays = 0,
    this.allergies = const {},
    this.chronicDiseases = const [],
    this.diets = const [],
    this.favoriteFoods = const [],
    this.favoriteTextures = const [],
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    birthDate,
    gender,
    photoUrl,
    streakDays,
    allergies,
    chronicDiseases,
    diets,
    favoriteFoods,
    favoriteTextures,
    notes,
  ];
}
