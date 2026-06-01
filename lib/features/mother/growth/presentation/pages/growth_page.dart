import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/constants/child_data_dummy.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';
import 'package:nusagizi/core/widgets/header_growth_development.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/add_new_data_bottom_sheets.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_head_circumference.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_height_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/chart_weight_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/status_card.dart';
import 'package:nusagizi/features/mother/growth/presentation/widgets/summary_card.dart';


enum GrowthTab { beratBadan, tinggiBadan, lKepala }

class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key});

  @override
  State<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  static const Color _bg = Color(0xFFF5F5F5);
  static const Color _green = Color(0xFF3CB648);

  int _selectedChildIndex = 0;
  ChildProfile get _dummyChild => dummyDataList[_selectedChildIndex].profile;
  GrowthRecord get _dummyLatest => dummyDataList[_selectedChildIndex].latest;
  List<GrowthRecord> get _dummyHistory =>
      dummyDataList[_selectedChildIndex].history;

  GrowthTab _activeTab = GrowthTab.beratBadan;

  /// Sub-halaman di dalam tab "Berat Badan": 0=BB/U, 1=BB vs TB, 2=IMT/U
  int _bbSubPage = 0;
  late final PageController _bbPageController;

  @override
  void initState() {
    super.initState();
    _bbPageController = PageController();
  }

  @override
  void dispose() {
    _bbPageController.dispose();
    super.dispose();
  }

  // ─── Child Picker ─────────────────────────────────────────────────────────
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
                'Grafik Tumbuh',
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
                          color: const Color(0xFFF5F5F5),
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
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          HeaderGrowthDevelopment(
            profile: _dummyChild,
            latest: _dummyLatest,
            accentColor: _green,
            onPickerTapped: _showChildPicker,
            onHistoryTapped: () =>
                context.goNamed(AppRoutes.growthHistory.name, extra: _dummyHistory),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SummaryCard(latest: _dummyLatest, accentColor: _green),
                  const SizedBox(height: 16),
                  _tabBar(),
                  const SizedBox(height: 16),
                  _chartCard(),
                  const SizedBox(height: 16),
                  StatusCard(
                    accentColor: _green,
                    profile: _dummyChild,
                    activeTab: _activeTab,
                    bbSubPage: _bbSubPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddNewDataBottomSheets(accentColor: _green),
    );
  }

  Widget _tabBar() {
    const labels = ['Berat Badan', 'Tinggi Badan', 'L.Kepala'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: GrowthTab.values.asMap().entries.map((e) {
          final isActive = _activeTab == e.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTab = e.value;
                  if (e.value == GrowthTab.beratBadan) {
                    _bbSubPage = 0;
                  }
                });
                // jumpToPage dipanggil setelah frame selesai di-build
                // agar PageController sudah terhubung ke PageView
                if (e.value == GrowthTab.beratBadan) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_bbPageController.hasClients) {
                      _bbPageController.jumpToPage(0);
                    }
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? _green : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    labels[e.key],
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _chartCard() {
    switch (_activeTab) {
      case GrowthTab.beratBadan:
        return ChartWeightCard(
          accentColor: _green,
          profile: _dummyChild,
          latest: _dummyLatest,
          history: _dummyHistory,
          bbSubPage: _bbSubPage,
          bbPageController: _bbPageController,
          onPageChanged: (i) => setState(() => _bbSubPage = i),
          onPrev: () {
            setState(() => _bbSubPage--);
            _bbPageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          onNext: () {
            setState(() => _bbSubPage++);
            _bbPageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        );
      case GrowthTab.tinggiBadan:
        return ChartHeightCard(
          profile: _dummyChild,
          latest: _dummyLatest,
          history: _dummyHistory,
        );
      case GrowthTab.lKepala:
        return ChartHeadCircumference(
          profile: _dummyChild,
          latest: _dummyLatest,
          history: _dummyHistory,
        );
    }
  }
}
