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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00B14F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _currentMonth.month,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF00B14F),
                    size: 18.sp,
                  ),
                  isDense: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  menuMaxHeight: 300.h,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B14F),
                  ),
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(_getMonthName(index + 1)),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, val);
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00B14F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _currentMonth.year,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF00B14F),
                    size: 18.sp,
                  ),
                  isDense: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  menuMaxHeight: 300.h,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B14F),
                  ),
                  items: () {
                    int startYear = 2000;
                    int endYear = 2045;

                    // Safety check to prevent Dropdown crash if initial date is outside 2000-2045
                    if (_currentMonth.year < startYear)
                      startYear = _currentMonth.year;
                    if (_currentMonth.year > endYear)
                      endYear = _currentMonth.year;

                    final int yearCount = endYear - startYear + 1;
                    return List.generate(yearCount, (index) {
                      final year = startYear + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    });
                  }(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _currentMonth = DateTime(val, _currentMonth.month);
                      });
                    }
                  },
                ),
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
