/// Utility untuk memformat tanggal ISO-8601 ke format tampilan berbahasa
/// Indonesia. Dipakai lintas fitur, sehingga diletakkan di `core/utils`.
class AppDateFormatter {
  const AppDateFormatter._();

  static const List<String> _indonesianMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Memformat string ISO-8601 (mis. `2024-05-12T00:00:00Z`) menjadi
  /// `12 Mei 2024`.
  ///
  /// Mengembalikan [isoString] apa adanya jika gagal di-parse.
  static String formatIndonesian(String isoString) {
    try {
      final parts = isoString.split('T').first.split('-');
      if (parts.length != 3) return isoString;

      final day = int.parse(parts[2]);
      final month = monthAbbreviation(int.parse(parts[1]));

      return '$day $month ${parts[0]}';
    } catch (_) {
      return isoString;
    }
  }

  /// Mengembalikan singkatan bulan berbahasa Indonesia untuk [month] (1-12).
  static String monthAbbreviation(int month) => _indonesianMonths[month - 1];

  /// Mem-parsing string berformat "DD-MM-YYYY" atau "YYYY-MM-DD" menjadi [DateTime].
  /// Mengembalikan [DateTime.now()] jika gagal diurai.
  static DateTime parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    if (!raw.contains('-')) return DateTime.now();

    final parts = raw.split('-');
    if (parts.length != 3) return DateTime.now();

    // Jika bagian pertama 4 digit, asumsikan YYYY-MM-DD
    if (parts[0].length == 4) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }

    // Selebihnya asumsikan DD-MM-YYYY
    return DateTime(
      int.tryParse(parts[2]) ?? 2026,
      int.tryParse(parts[1]) ?? 1,
      int.tryParse(parts[0]) ?? 1,
    );
  }

  /// Menghitung usia (contoh: "2 Tahun 3 Bulan" atau "5 Bulan")
  static String calculateAge(DateTime bdate) {
    final now = DateTime.now();
    int years = now.year - bdate.year;
    int months = now.month - bdate.month;
    if (now.day < bdate.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }
    return years > 0 ? '$years Tahun $months Bulan' : '$months Bulan';
  }
}
