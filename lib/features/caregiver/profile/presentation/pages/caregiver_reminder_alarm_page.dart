import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/constants/alarm_dummy_data.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/reminder_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_alarm_cubit.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_alarm_state.dart';

class CaregiverReminderAlarmPage extends StatefulWidget {
  const CaregiverReminderAlarmPage({super.key});

  @override
  State<CaregiverReminderAlarmPage> createState() =>
      _CaregiverReminderAlarmPageState();
}

class _CaregiverReminderAlarmPageState
    extends State<CaregiverReminderAlarmPage> {
  @override
  void initState() {
    super.initState();
    context.read<CaregiverAlarmCubit>().initializeIfEmpty();
  }

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
                child: BlocBuilder<CaregiverAlarmCubit, CaregiverAlarmState>(
                  builder: (context, state) {
                    final alarms = state.alarms;
                    return ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        final visuals = alarmDummyData[index];
                        return ReminderTile(
                          icon: visuals['icon'] as IconData,
                          iconColor: visuals['iconColor'] as Color,
                          bgColor: visuals['bgColor'] as Color,
                          title: alarm.title,
                          time:
                              "${alarm.hour.toString().padLeft(2, '0')}.00 - ${(alarm.hour + 1).toString().padLeft(2, '0')}.00",
                          isSwitchedOn: alarm.isActive,
                          isFirst: index == 0,
                          isLast: index == alarms.length - 1,
                          onChanged: (_) {
                            context.read<CaregiverAlarmCubit>().toggleAlarm(
                              index,
                            );
                          },
                        );
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
