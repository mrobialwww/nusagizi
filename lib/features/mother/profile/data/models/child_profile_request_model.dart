class ChildProfileRequestModel {
  final String fullName;
  final String birthDate;
  final String gender;
  final String? photoUrl;
  final Map<String, List<String>> allergies;
  final List<String> chronicDiseases;
  final List<String> diets;
  final List<String> favoriteFoods;
  final List<String> favoriteTextures;
  final String? notes;

  ChildProfileRequestModel({
    required this.fullName,
    required this.birthDate,
    required this.gender,
    this.photoUrl,
    this.allergies = const {},
    this.chronicDiseases = const [],
    this.diets = const [],
    this.favoriteFoods = const [],
    this.favoriteTextures = const [],
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "birth_date": birthDate,
      "gender": gender,
      if (photoUrl != null) "photo_url": photoUrl,
      if (allergies.isNotEmpty) "allergies": allergies,
      if (chronicDiseases.isNotEmpty) "chronic_diseases": chronicDiseases,
      if (diets.isNotEmpty) "diets": diets,
      if (favoriteFoods.isNotEmpty) "favorite_foods": favoriteFoods,
      if (favoriteTextures.isNotEmpty) "favorite_textures": favoriteTextures,
      if (notes != null && notes!.isNotEmpty) "notes": notes,
    };
  }
}
