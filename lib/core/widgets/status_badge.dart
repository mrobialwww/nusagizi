import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final FontWeight fontWeight;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontWeight = FontWeight.w500,
  });

  static Color getColorForStatus(String status) {
    final statusLower = status.toLowerCase();

    // Green (Normal / Sesuai / Tumbuh Optimal / Hijau)
    if (statusLower == 'normal' ||
        statusLower == 'sesuai usia' ||
        statusLower == 'tumbuh optimal' ||
        statusLower == 'hijau') {
      return const Color(0xFF00B14F);
    }
    // Blue (Perkembangan Baik)
    else if (statusLower == 'perkembangan baik') {
      return const Color(0xFF4285F4);
    }
    // Yellow (Peringatan ringan: Kembang & Gizi / Perlu Perhatian)
    else if (statusLower == 'perkembangan meragukan' ||
        statusLower == 'kurang optimal' ||
        statusLower == 'perlu perhatian' ||
        statusLower == 'kuning') {
      return Colors.amber.shade500;
    }
    // Orange (Berisiko: Tumbuh & Gizi / Perlu Pendampingan)
    else if (statusLower == 'berisiko' ||
        statusLower == 'beresiko' ||
        statusLower == 'perlu pendampingan' ||
        statusLower == 'oranye') {
      return Colors.orange;
    }
    // Red (Bahaya / Buruk / Perlu Konsultasi)
    else if (statusLower == 'sangat buruk' ||
        statusLower == 'kemungkinan penyimpangan' ||
        statusLower == 'perlu konsultasi' ||
        statusLower == 'merah') {
      return Colors.red;
    }

    return Colors.grey; // Default fallback
  }

  Color get _statusColor => getColorForStatus(status);

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8.sp, color: color),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              status,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.sp,
                fontWeight: fontWeight,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
