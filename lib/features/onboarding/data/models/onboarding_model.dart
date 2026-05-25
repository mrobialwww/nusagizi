class OnboardingModel {
  final String role;
  final String gender;
  final int age;

  OnboardingModel({
    required this.role,
    required this.gender,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'gender': gender,
      'age': age,
    };
  }
}
