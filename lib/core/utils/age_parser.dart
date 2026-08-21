/// Konversi string usia seperti "2 Tahun 3 Bulan" / "18 Bulan" ke jumlah bulan.
///
/// Contoh:
/// - "2 Tahun 3 Bulan" → 27
/// - "18 Bulan" → 18
/// - "1 tahun 6 bulan" → 18
/// - "3 Tahun" → 36
int parseAgeToMonths(String age) {
  int months = 0;
  final tahun = RegExp(r'(\d+)\s*tahun', caseSensitive: false).firstMatch(age);
  final bulan = RegExp(r'(\d+)\s*bulan', caseSensitive: false).firstMatch(age);
  if (tahun != null) months += int.parse(tahun.group(1)!) * 12;
  if (bulan != null) months += int.parse(bulan.group(1)!);
  return months;
}
