import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGrowthPage extends StatefulWidget {
  const AddGrowthPage({super.key});

  @override
  State<AddGrowthPage> createState() => _AddGrowthPageState();
}

class _AddGrowthPageState extends State<AddGrowthPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime tempDate = _selectedDate ?? DateTime.now();

    final DateTime? picked = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          'Select Date',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _CustomCalendarPicker(
                        initialDate: tempDate,
                        onDateChanged: (DateTime newDate) {
                          setDialogState(() {
                            tempDate = newDate;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.outfit(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, tempDate),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B14F),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, 1), // Dari luar layar (bawah)
                end: Offset.zero, // Ke tengah
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic, // Untuk saat muncul
                  reverseCurve: Curves.easeInCubic, // Untuk saat menghilang
                ),
              ),
          child: child,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFCFCFC,
      ), // Mirip putih tapi sedikit off-white
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFCFC),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Tambah Data Pertumbuhan',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('Tanggal Pertumbuhan'),
                      _buildTextField(
                        hintText: _selectedDate == null
                            ? 'Select Date'
                            : _formatDate(_selectedDate!),
                        suffixIcon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),

                      _buildInputLabel('Usia Anak', isRequired: false),
                      _buildTextField(hintText: '2 Tahun 3 Bulan'),
                      const SizedBox(height: 16),

                      _buildInputLabel('Berat Badan (kg)'),
                      _buildTextField(hintText: '12.4kg'),
                      const SizedBox(height: 16),

                      _buildInputLabel('Tinggi Badan (cm)'),
                      _buildTextField(hintText: '89cm'),
                      const SizedBox(height: 16),

                      _buildInputLabel('Lingkar Kepala (cm)'),
                      _buildTextField(hintText: '47cm'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F), // Hijau Nuzagizi
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          children: [
            if (isRequired)
              TextSpan(
                text: '*',
                style: GoogleFonts.outfit(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(color: Colors.black54, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.black54, size: 20)
              : null,
        ),
        style: GoogleFonts.outfit(color: Colors.black87, fontSize: 14),
      ),
    );
  }
}

class _CustomCalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const _CustomCalendarPicker({
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<_CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<_CustomCalendarPicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun
    final offset = firstWeekday == 7 ? 0 : firstWeekday;
    final prevMonthDays = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      0,
    ).day;

    List<Widget> dayWidgets = [];

    // Header Hari
    const weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    for (var day in weekDays) {
      dayWidgets.add(
        Center(
          child: Text(
            day,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      );
    }

    // Hari dari bulan sebelumnya
    for (int i = 0; i < offset; i++) {
      int dayNumber = prevMonthDays - offset + i + 1;
      dayWidgets.add(
        Center(
          child: Text(
            '$dayNumber',
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.black38),
          ),
        ),
      );
    }

    // Hari di bulan ini
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, i);
      final isSelected =
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            widget.onDateChanged(_selectedDate);
          },
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00B14F)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$i',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Hari di bulan berikutnya
    int totalCellsFilled = offset + daysInMonth;
    int nextMonthDaysNeeded = 42 - totalCellsFilled;
    for (int i = 1; i <= nextMonthDaysNeeded; i++) {
      dayWidgets.add(
        Center(
          child: Text(
            '$i',
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.black38),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _prevMonth,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black54,
                size: 24,
              ),
            ),
            const SizedBox(width: 24),
            Text(
              '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: _nextMonth,
              child: const Icon(
                Icons.chevron_right,
                color: Colors.black54,
                size: 24,
              ),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          mainAxisSpacing: 8,
          children: dayWidgets,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
