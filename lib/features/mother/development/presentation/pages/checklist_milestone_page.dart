import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/checklist_milestone_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/checklist_milestone_state.dart';
import 'package:nusagizi/core/utils/age_parser.dart';

class ChecklistMilestonePage extends StatefulWidget {
  final String childId;
  final String childAge;

  const ChecklistMilestonePage({
    super.key,
    required this.childId,
    required this.childAge,
  });

  @override
  State<ChecklistMilestonePage> createState() => _ChecklistMilestonePageState();
}

class _ChecklistMilestonePageState extends State<ChecklistMilestonePage> {
  static const Color _green = Color(0xFF00A735);
  static const Color _bg = Color(0xFFF5F5F5);
  static const List<int> _months = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    30,
    36,
    42,
    48,
    54,
    60,
  ];

  late final ChecklistMilestoneCubit _cubit;
  late int _selectedMonth;
  final GlobalKey _selectedTabKey = GlobalKey();

  int _snapToPeriod(int months) {
    return _months.lastWhere((p) => p <= months, orElse: () => _months.first);
  }

  @override
  void initState() {
    super.initState();
    _cubit = sl<ChecklistMilestoneCubit>();
    final totalMonths = parseAgeToMonths(widget.childAge);
    _selectedMonth = _snapToPeriod(totalMonths);
    _cubit.loadTasks(childId: widget.childId, monthTarget: _selectedMonth);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTabKey.currentContext != null) {
        Scrollable.ensureVisible(
          _selectedTabKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _domainLabel(String domain) {
    switch (domain) {
      case 'gross_motor_skills':
        return 'Motorik Kasar';
      case 'fine_motor_skills':
        return 'Motorik Halus';
      case 'speech_and_language':
        return 'Bicara & Bahasa';
      case 'socialization':
        return 'Sosialisasi & Kemandirian';
      default:
        return domain;
    }
  }

  IconData _getIconForDomain(String domain) {
    switch (domain) {
      case 'gross_motor_skills':
        return Icons.directions_run_rounded;
      case 'fine_motor_skills':
        return Icons.draw_rounded;
      case 'speech_and_language':
        return Icons.record_voice_over_rounded;
      case 'socialization':
        return Icons.people_alt_rounded;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: HeaderBasic(
          backgroundColor: Colors.white,
          title: 'Checklist Milestone',
          subtitle: widget.childAge,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 16.h),
            _buildMonthTabs(),
            SizedBox(height: 24.h),
            Expanded(
              child:
                  BlocBuilder<ChecklistMilestoneCubit, ChecklistMilestoneState>(
                    builder: (context, state) {
                      if (state is ChecklistMilestoneLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A735),
                          ),
                        );
                      }
                      if (state is ChecklistMilestoneError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is ChecklistMilestoneLoaded) {
                        final tasks = state.tasks;
                        final grouped = _groupByDomain(tasks);
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: grouped.length,
                          itemBuilder: (context, index) {
                            final domain = grouped.keys.elementAt(index);
                            final domainTasks = grouped[domain]!;
                            return _buildDomainCard(domain, domainTasks);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<ChecklistMilestoneTaskEntity>> _groupByDomain(
    List<ChecklistMilestoneTaskEntity> tasks,
  ) {
    final map = <String, List<ChecklistMilestoneTaskEntity>>{};
    for (final task in tasks) {
      map.putIfAbsent(task.developmentalDomain, () => []).add(task);
    }
    return map;
  }

  Widget _buildMonthTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: _months.map((month) {
          final isSelected = month == _selectedMonth;
          return GestureDetector(
            onTap: isSelected
                ? () {
                    setState(() {
                      _selectedMonth = month;
                    });
                    _cubit.loadTasks(
                      childId: widget.childId,
                      monthTarget: _selectedMonth,
                    );
                  }
                : null,
            child: Opacity(
              opacity: isSelected ? 1.0 : 0.75,
              child: Container(
                key: isSelected ? _selectedTabKey : null,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? _green : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isSelected ? _green : const Color(0xFFE0E0E0),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _green.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  '$month Bulan',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: isSelected ? Colors.white : _green,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDomainCard(
    String domain,
    List<ChecklistMilestoneTaskEntity> tasks,
  ) {
    final completedCount = tasks.where((t) => t.isChecked).length;
    final totalCount = tasks.length;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
          tilePadding: EdgeInsets.all(16.w),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEFDD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForDomain(domain),
                  size: 20.sp,
                  color: _green,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _domainLabel(domain),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$completedCount/$totalCount selesai',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(
              color: Color(0xFFDDEFDD),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.expand_less_rounded, color: _green, size: 20.sp),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Column(
                children: [
                  const Divider(color: Color(0xFFF0F0F0), height: 1),
                  SizedBox(height: 12.h),
                  ...tasks.map((task) => _buildCheckboxItem(task)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(ChecklistMilestoneTaskEntity task) {
    return GestureDetector(
      onTap: () => _cubit.toggleTask(task.id),
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: task.isChecked ? _green : const Color(0xFFD0D0D0),
                  width: 1.5,
                ),
                color: task.isChecked ? _green : Colors.white,
              ),
              child: task.isChecked
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                task.questionText,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  color: Colors.black87,
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
