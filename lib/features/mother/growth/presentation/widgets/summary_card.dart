import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/app_card.dart';

String _monthName(int m) => const [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
][m];

class SummaryCard extends StatelessWidget {
  final GrowthRecord latest;
  final Color accentColor;

  const SummaryCard({
    super.key,
    required this.latest,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final r = latest;
    final d = r.date;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')} ${_monthName(d.month)} ${d.year}';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Tumbuh',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              _badge('Normal', accentColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Terakhir diperbarui: $dateStr',
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.black45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _measureItem(
                  Icons.monitor_weight_outlined,
                  'Berat',
                  '${r.weight} kg',
                ),
              ),
              Expanded(
                child: _measureItem(
                  Icons.straighten_rounded,
                  'Tinggi',
                  '${r.height.toInt()} cm',
                ),
              ),
              Expanded(
                child: _measureItem(
                  Icons.circle_outlined,
                  'L.Kepala',
                  '${r.headCircumference.toInt()} cm',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _measureItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: Colors.blueGrey),
            const SizedBox(width: 3),
            Text(
              label,
              style: GoogleFonts.outfit(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
