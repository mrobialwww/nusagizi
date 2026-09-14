import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/constants/alarm_dummy_data.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/reminder_tile.dart';

class ReminderAlarmPage extends StatefulWidget {
  const ReminderAlarmPage({super.key});

  @override
  State<ReminderAlarmPage> createState() => _ReminderAlarmPageState();
}

class _ReminderAlarmPageState extends State<ReminderAlarmPage> {
  final List<Map<String, dynamic>> _alarms = alarmDummyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const HeaderBasic(
        title: "Jadwal & Pengingat",
        backgroundColor: Color(0xFFFAFAFA),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = _alarms[index];
                    return ReminderTile(
                      icon: alarm['icon'],
                      iconColor: alarm['iconColor'],
                      bgColor: alarm['bgColor'],
                      title: alarm['title'],
                      time: alarm['time'],
                      isSwitchedOn: alarm['isOn'],
                      isFirst: index == 0,
                      isLast: index == _alarms.length - 1,
                      onChanged: (val) {
                        setState(() {
                          _alarms[index]['isOn'] = val;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
