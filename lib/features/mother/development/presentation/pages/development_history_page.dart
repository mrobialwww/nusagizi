import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/history_timeline_card.dart';
import 'package:nusagizi/router.dart';

class DevelopmentHistoryPage extends StatelessWidget {
  const DevelopmentHistoryPage({super.key});

  static const Color _green = Color(0xFF3CB648);
  static const Color _bg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Riwayat Perkembangan',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            HistoryTimelineCard(
              isFirst: true,
              isLast: false,
              type: HistoryType.checklist,
              date: '11 Mei',
              monthTitle: 'Bulan 24',
              contentWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_run_rounded,
                            size: 14,
                            color: _green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Motorik Kasar',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '3/3',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.draw_rounded,
                            size: 14,
                            color: _green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Motorik Halus',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '2/2',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '"Si kecil sudah lancar berjalan mundur."',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HistoryTimelineCard(
              isFirst: false,
              isLast: false,
              type: HistoryType.kpsp,
              date: '05 Mei',
              monthTitle: 'Bulan 24',
              contentWidget: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _green, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '9',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: _green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sesuai Tahap',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: _green,
                          ),
                        ),
                        Text(
                          'Perkembangan optimal',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            HistoryTimelineCard(
              isFirst: false,
              isLast: true,
              type: HistoryType.checklist,
              date: '30 Apr',
              monthTitle: 'Bulan 23',
              contentWidget: Text(
                'Telah mengisi 4 domain\nperkembangan.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildNewAssessmentCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNewAssessmentCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment, color: _green, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'Waktunya Asesmen Baru?',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pastikan perkembangan si kecil selalu terpantau dengan baik.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.developmentKpsp.name,
                  extra: const KpspAssessmentExtra(
                    childName: 'Alya', // using a dummy name for now
                    childAge: '24 Bulan', // dummy for now
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Mulai KPSP Baru',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.developmentChecklist.name,
                  extra: '24 Bulan', // dummy for now
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.transparent),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Update Checklist',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
