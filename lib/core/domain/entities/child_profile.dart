class ChildProfile {
  final String name;
  final DateTime birthDate;

  const ChildProfile({required this.name, required this.birthDate});

  String get ageString {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return '$years Tahun $months Bulan';
  }
}
