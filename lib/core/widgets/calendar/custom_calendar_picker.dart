import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const CustomCalendarPicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
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
    const weekDays = ['Mg', 'Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb'];
    for (var day in weekDays) {
      dayWidgets.add(
        Center(
          child: Text(
            day,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13.sp,
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
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Colors.black38,
            ),
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
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00B14F)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$i',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13.sp,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Colors.black38,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _prevMonth,
              child: Icon(
                Icons.chevron_left,
                color: Colors.black54,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 24.w),
            Text(
              '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 24.w),
            GestureDetector(
              onTap: _nextMonth,
              child: Icon(
                Icons.chevron_right,
                color: Colors.black54,
                size: 24.sp,
              ),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          mainAxisSpacing: 8.h,
          children: dayWidgets,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
