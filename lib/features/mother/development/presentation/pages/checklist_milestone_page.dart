import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChecklistMilestonePage extends StatefulWidget {
  final String childAge;

  const ChecklistMilestonePage({
    super.key,
    required this.childAge,
  });

  @override
  State<ChecklistMilestonePage> createState() => _ChecklistMilestonePageState();
}

class _ChecklistMilestonePageState extends State<ChecklistMilestonePage> {
  static const Color _green = Color(0xFF3CB648);
  static const Color _bg = Color(0xFFF5F5F5);

  final List<String> _months = ['18 Bulan', '24 Bulan', '30 Bulan'];
  String _selectedMonth = '24 Bulan';

  // Dummy data structure: Domain -> List of (Task, isCompleted)
  late Map<String, List<Map<String, dynamic>>> _checklistData;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.childAge;
    if (!_months.contains(_selectedMonth)) {
      _selectedMonth = '24 Bulan'; // default fallback
    }
    _initDummyData();
  }

  void _initDummyData() {
    _checklistData = {
      'Motorik Kasar': [
        {'task': 'Berjalan mundur 5 langkah tanpa jatuh', 'isCompleted': false},
        {'task': 'Menendang bola kecil ke depan', 'isCompleted': false},
        {'task': 'Melompat dengan kedua kaki bersamaan', 'isCompleted': false},
      ],
      'Motorik Halus': [
        {'task': 'Menyusun 4-6 balok', 'isCompleted': false},
        {'task': 'Mencoret di kertas menggunakan krayon/pensil', 'isCompleted': false},
        {'task': 'Membalik halaman buku satu per satu', 'isCompleted': false},
      ],
      'Bicara & Bahasa': [
        {'task': 'Menyebut nama orang terdekat', 'isCompleted': false},
        {'task': 'Mengucapkan 2-3 kata sekaligus', 'isCompleted': false},
        {'task': 'Menunjuk benda saat disebutkan', 'isCompleted': false},
      ],
      'Sosialisasi & Kemandirian': [
        {'task': 'Makan sendiri', 'isCompleted': false},
        {'task': 'Minum dari gelas sendiri', 'isCompleted': false},
        {'task': 'Bermain dengan anak lain', 'isCompleted': false},
      ],
    };
  }

  IconData _getIconForDomain(String domain) {
    switch (domain) {
      case 'Motorik Kasar':
        return Icons.directions_run_rounded;
      case 'Motorik Halus':
        return Icons.draw_rounded;
      case 'Bicara & Bahasa':
        return Icons.record_voice_over_rounded;
      case 'Sosialisasi & Kemandirian':
        return Icons.people_alt_rounded;
      default:
        return Icons.check_circle_outline;
    }
  }

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
        title: Column(
          children: [
            Text(
              'Checklist Milestone',
              style: GoogleFonts.outfit(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              widget.childAge,
              style: GoogleFonts.outfit(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildMonthTabs(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _checklistData.length,
              itemBuilder: (context, index) {
                final domain = _checklistData.keys.elementAt(index);
                final tasks = _checklistData[domain]!;
                return _buildDomainCard(domain, tasks);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _months.map((month) {
          final isSelected = month == _selectedMonth;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonth = month;
                // In a real app, we'd load new data here based on the selected month
                // For now, we just reset the dummy data to simulate a new list
                _initDummyData();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? _green : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? _green : const Color(0xFFE0E0E0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _green.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                month,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? Colors.white : _green,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDomainCard(String domain, List<Map<String, dynamic>> tasks) {
    final completedCount = tasks.where((t) => t['isCompleted'] == true).length;
    final totalCount = tasks.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.all(16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEFDD),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconForDomain(domain), size: 20, color: _green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedCount/$totalCount selesai',
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
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFDDEFDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.expand_less_rounded, color: _green, size: 20),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: [
                  const Divider(color: Color(0xFFF0F0F0), height: 1),
                  const SizedBox(height: 12),
                  ...tasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;
                    return _buildCheckboxItem(task, index, domain);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(Map<String, dynamic> task, int index, String domain) {
    final isCompleted = task['isCompleted'] as bool;
    return GestureDetector(
      onTap: () {
        setState(() {
          task['isCompleted'] = !isCompleted;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCompleted ? _green : const Color(0xFFD0D0D0),
                  width: 1.5,
                ),
                color: isCompleted ? _green : Colors.white,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task['task'],
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isCompleted ? Colors.black54 : Colors.black87,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
