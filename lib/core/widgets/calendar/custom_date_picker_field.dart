import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nusagizi/core/widgets/calendar/custom_calendar_picker.dart';

class CustomDatePickerField extends StatefulWidget {
  final String hint;
  final IconData? suffixIcon;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePickerField({
    super.key,
    required this.hint,
    this.suffixIcon = Icons.calendar_today,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? _formatDate(_selectedDate!) : '',
    );
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _controller.text = _formatDate(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final List<String> months = [
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

    // Fallback if weekday/month out of range (shouldn't happen with DateTime, but good practice)
    final dayName = date.weekday >= 1 && date.weekday <= 7
        ? days[date.weekday - 1]
        : '';
    final monthName = date.month >= 1 && date.month <= 12
        ? months[date.month - 1]
        : '';

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

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
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                        child: Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CustomCalendarPicker(
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
                            onPressed: () => context.pop(),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            onPressed: () => context.pop(tempDate),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B14F),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 10.h,
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
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
        _controller.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFF00A735)),
            ),
            suffixIcon: widget.suffixIcon != null
                ? Icon(widget.suffixIcon, color: Colors.grey, size: 20.sp)
                : null,
          ),
        ),
      ),
    );
  }
}
