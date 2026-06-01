import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/constants/child_data_dummy.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/header_growth_development.dart';
import 'package:nusagizi/core/routes/route_args.dart';

import 'package:nusagizi/router.dart';

import 'package:nusagizi/features/mother/development/presentation/widgets/development_summary_card.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_profile_card.dart';

import 'package:nusagizi/core/constants/dummy_child_development_summaries.dart';

class DevelopmentPage extends StatefulWidget {
  const DevelopmentPage({super.key});

  @override
  State<DevelopmentPage> createState() => _DevelopmentPageState();
}

class _DevelopmentPageState extends State<DevelopmentPage> {
  static const Color _bg = Color(0xFFF5F5F5);
  static const Color _green = Color(0xFF3CB648);

  int _selectedChildIndex = 0;
  ChildProfile get _dummyChild => dummyDataList[_selectedChildIndex].profile;
  GrowthRecord get _dummyLatest => dummyDataList[_selectedChildIndex].latest;

  void _showChildPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Grafik Tumbuh Kembang',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pilih Profil Anak',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ...List.generate(dummyDataList.length, (index) {
                final childData = dummyDataList[index];
                final isSelected = index == _selectedChildIndex;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFDDEFDD),
                            child: Text(
                              childData.profile.name[0],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: _green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: _green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        childData.profile.name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        childData.profile.ageString,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedChildIndex = index;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final devData = dummyChildDevelopmentSummaries[_selectedChildIndex];

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          HeaderGrowthDevelopment(
            profile: _dummyChild,
            latest: _dummyLatest,
            onPickerTapped: _showChildPicker,
            onHistoryTapped: () =>
                context.goNamed(AppRoutes.developmentHistory.name),
            accentColor: _green,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DevelopmentSummaryCard(
                    badgeStatus: devData.badgeStatus,
                    badgeColor: devData.badgeColor,
                    badgeBgColor: devData.badgeBgColor,
                    lastCheck: devData.lastCheck,
                    kpspScore: devData.kpspScore,
                    nextCheck: devData.nextCheck,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Akses Cepat',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Asesmen KPSP',
                          subtitle: 'Cek rutin perkembangan',
                          icon: Icons.assignment_outlined,
                          iconBackgroundColor: const Color(0xFFDDEFDD),
                          iconColor: const Color(0xFF3CB648),
                          decorationColor: const Color(0xFFDDEFDD),
                          onTap: () {
                            context.goNamed(
                              AppRoutes.developmentKpsp.name,
                              extra: KpspAssessmentExtra(
                                childName: _dummyChild.name,
                                childAge: _dummyChild.ageString,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Checklist Manual',
                          subtitle: 'Pantau harian mandiri',
                          icon: Icons.fact_check_outlined,
                          iconBackgroundColor: const Color(0xFFFFEBD6),
                          iconColor: const Color(0xFFFF9800),
                          decorationColor: const Color(0xFFFFEBD6),
                          onTap: () => context.goNamed(
                            AppRoutes.developmentChecklist.name,
                            extra: _dummyChild.ageString,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DevelopmentProfileCard(
                    childName: _dummyChild.name,
                    childAge: _dummyChild.ageString,
                    motorikHalus: devData.motorikHalus,
                    motorikKasar: devData.motorikKasar,
                    sosialisasi: devData.sosialisasi,
                    bicara: devData.bicara,
                    motorikHalusStatus: devData.motorikHalusStatus,
                    motorikKasarStatus: devData.motorikKasarStatus,
                    sosialisasiStatus: devData.sosialisasiStatus,
                    bicaraStatus: devData.bicaraStatus,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required Color decorationColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 136, // Diperbesar sedikit agar tidak overflow
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ornamen lingkaran di pojok kanan bawah
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: decorationColor.withOpacity(0.3),
                ),
              ),
            ),
            // Konten
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
