import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
// Untuk import GrowthRecord

class GrowthHistoryPage extends StatefulWidget {
  final List<GrowthRecord> history;

  const GrowthHistoryPage({super.key, required this.history});

  @override
  State<GrowthHistoryPage> createState() => _GrowthHistoryPageState();
}

class _GrowthHistoryPageState extends State<GrowthHistoryPage> {
  String _sortOrder = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    // Urutkan berdasarkan _sortOrder
    final sortedHistory = _sortOrder == 'Terbaru'
        ? widget.history.reversed.toList()
        : widget.history.toList();

    String formatDate(DateTime date) {
      const months = [
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
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Riwayat Pertumbuhan',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Dropdown Urutkan (UI Only)
            GestureDetector(
              onTap: _showSortPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sortOrder == 'Terbaru' ? 'Urutkan' : 'Terlama',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: sortedHistory.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final record = sortedHistory[index];

                  // Dummy logika untuk status "Perlu Perhatian"
                  final isWarning =
                      record.weight < 10.0 && index > 0; // Contoh kondisi acak

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(record.date),
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isWarning
                                    ? const Color(0xFFFFEAEA)
                                    : const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isWarning
                                          ? Colors.red
                                          : const Color(0xFF3CB648),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isWarning ? 'Perlu Perhatian' : 'Normal',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isWarning
                                          ? Colors.red
                                          : const Color(0xFF3CB648),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildInfoBox(
                              'Berat',
                              '${record.weight}',
                              'kg',
                              Icons.monitor_weight_outlined,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoBox(
                              'Tinggi',
                              '${record.height.toInt()}',
                              'cm',
                              Icons.height,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoBox(
                              'L.Kepala',
                              '${record.headCircumference.toInt()}',
                              'cm',
                              Icons.face_outlined,
                            ),
                          ],
                        ),
                        if (isWarning) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEAEA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Berat badan anak berada di bawah rentang ideal untuk usianya. Perhatikan asupan makan harian dan lakukan pemantauan rutin.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.red,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 12, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Urutkan',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Terbaru',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terbaru';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Terlama',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOrder = 'Terlama';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
