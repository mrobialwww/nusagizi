import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/widgets/app_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/pages/growth_page.dart';

class StatusCard extends StatelessWidget {
  final Color accentColor;
  final ChildProfile profile;
  final GrowthTab activeTab;
  final int bbSubPage;

  const StatusCard({
    super.key,
    required this.accentColor,
    required this.profile,
    required this.activeTab,
    required this.bbSubPage,
  });

  @override
  Widget build(BuildContext context) {
    final (title, desc) = _statusConfig();
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 10, color: Color(0xFF3CB648)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _statusConfig() {
    final name = profile.name.split(' ').last;
    switch (activeTab) {
      case GrowthTab.beratBadan:
        switch (bbSubPage) {
          case 0:
            return (
              'Berat Normal',
              'Berat badan $name berada dalam rentang normal sesuai usianya. '
                  'Pertahankan pola makan seimbang dan pemantauan rutin untuk mendukung pertumbuhan optimal.',
            );
          case 1:
            return (
              'Gizi Normal',
              'Berat badan $name sesuai dengan tinggi badannya, menunjukkan '
                  'proporsi tubuh yang baik dan risiko gizi yang rendah.',
            );
          case 2:
          default:
            return (
              'Gizi Normal',
              'Indeks Massa Tubuh $name berada pada kategori normal sesuai usia, '
                  'menandakan keseimbangan asupan dan pertumbuhan yang baik.',
            );
        }
      case GrowthTab.tinggiBadan:
        return (
          'Tinggi Normal',
          'Tinggi badan $name berada dalam rentang sesuai usia. '
              'Pertumbuhan tinggi badan menunjukkan perkembangan yang baik.',
        );
      case GrowthTab.lKepala:
        return (
          'Lingkar Kepala Normal',
          'Ukuran lingkar kepala $name sesuai dengan usianya dan menunjukkan pertumbuhan otak yang baik.',
        );
    }
  }
}
