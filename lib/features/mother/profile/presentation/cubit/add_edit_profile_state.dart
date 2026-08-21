import 'package:equatable/equatable.dart';

class AddEditProfileState extends Equatable {
  final String fullName;
  final DateTime? birthDate;
  final String gender;
  final String? photoUrl;
  final Map<String, List<String>> allergies;
  final List<String> chronicDiseases;
  final List<String> diets;
  final List<String> favoriteFoods;
  final List<String> favoriteTextures;
  final String? notes;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumferenceCm;
  final bool isLoading;
  final String? errorMessage;

  const AddEditProfileState({
    this.fullName = '',
    this.birthDate,
    this.gender = 'male',
    this.photoUrl,
    this.allergies = const {},
    this.chronicDiseases = const [],
    this.diets = const [],
    this.favoriteFoods = const [],
    this.favoriteTextures = const [],
    this.notes,
    this.weightKg,
    this.heightCm,
    this.headCircumferenceCm,
    this.isLoading = false,
    this.errorMessage,
  });

  AddEditProfileState copyWith({
    String? fullName,
    DateTime? birthDate,
    String? gender,
    String? photoUrl,
    Map<String, List<String>>? allergies,
    List<String>? chronicDiseases,
    List<String>? diets,
    List<String>? favoriteFoods,
    List<String>? favoriteTextures,
    String? notes,
    double? weightKg,
    double? heightCm,
    double? headCircumferenceCm,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddEditProfileState(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      diets: diets ?? this.diets,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      favoriteTextures: favoriteTextures ?? this.favoriteTextures,
      notes: notes ?? this.notes,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      headCircumferenceCm: headCircumferenceCm ?? this.headCircumferenceCm,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    birthDate,
    gender,
    photoUrl,
    allergies,
    chronicDiseases,
    diets,
    favoriteFoods,
    favoriteTextures,
    notes,
    weightKg,
    heightCm,
    headCircumferenceCm,
    isLoading,
    errorMessage,
  ];
}
