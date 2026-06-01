class OnboardingModel {
  final String role;

  OnboardingModel({
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
    };
  }
}
