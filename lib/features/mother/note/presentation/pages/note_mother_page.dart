import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_entity.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_notes_cubit.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_notes_state.dart';
import 'package:nusagizi/features/mother/note/presentation/widgets/note_card.dart';
import 'package:nusagizi/features/mother/note/presentation/widgets/note_empty_state.dart';
import 'package:nusagizi/features/mother/note/presentation/widgets/note_filter_dropdown.dart';
import 'package:nusagizi/features/mother/note/presentation/widgets/note_selection_sheet.dart';
import 'package:intl/intl.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';

class NoteMotherPage extends StatefulWidget {
  const NoteMotherPage({super.key});

  @override
  State<NoteMotherPage> createState() => _NoteMotherPageState();
}

class _NoteMotherPageState extends State<NoteMotherPage> {
  late final GoRouterDelegate _routerDelegate;
  late final AppLifecycleListener _lifecycleListener;
  bool _wasPaused = false;
  String _selectedChild = 'Semua Anak';
  late String _selectedMonth;
  late final MedicalNotesCubit _notesCubit;

  static const List<String> _months = [
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

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onPause: () => _wasPaused = true,
      onResume: () {
        if (_wasPaused && motherNavTabNotifier.value == 1) _fetchNotes();
        _wasPaused = false;
      },
    );
    motherNavTabNotifier.addListener(_onTabChanged);

    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate.addListener(_onRouteChanged);

    _selectedMonth =
        _months[DateTime.now().month -
            1]; // Default to the current month dynamically
    _notesCubit = sl<MedicalNotesCubit>();
    _fetchNotes();
  }

  void _onRouteChanged() {
    if (!mounted) return;
    try {
      final String location = _routerDelegate.currentConfiguration.uri
          .toString();
      if (location == '/note-mother' && motherNavTabNotifier.value == 1) {
        _fetchNotes();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    motherNavTabNotifier.removeListener(_onTabChanged);
    _routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onTabChanged() {
    // Index 1 adalah NoteMotherPage
    if (motherNavTabNotifier.value == 1) {
      _fetchNotes();
    }
  }

  void _fetchNotes() {
    _notesCubit.fetchMedicalNotes(
      status: 'active',
      month: _months.indexOf(_selectedMonth) + 1,
      childName: _selectedChild == 'Semua Anak' ? null : _selectedChild,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: HeaderBasic(
        backgroundColor: const Color(0xFFFAFAFA),
        title: "Catatan Konsultasi",
        actions: [
          GestureDetector(
            onTap: () => context.pushNamed(AppRoutes.noteHistory.name),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.history_rounded,
                size: 22.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<ChildrenCacheCubit>()),
            BlocProvider.value(value: _notesCubit),
          ],
          child: BlocBuilder<ChildrenCacheCubit, List<ChildHeaderEntity>>(
            builder: (context, childrenList) {
              return Column(
                children: [
                  Expanded(
                    child: BlocBuilder<MedicalNotesCubit, MedicalNotesState>(
                      builder: (context, state) {
                        if (state is MedicalNotesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00A735),
                            ),
                          );
                        } else if (state is MedicalNotesError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48.sp,
                                  color: Colors.red.shade300,
                                ),
                                SizedBox(height: 16.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                  ),
                                  child: Text(
                                    state.message,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.red.shade400,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                OutlinedButton.icon(
                                  onPressed: _fetchNotes,
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 18.sp,
                                    color: const Color(0xFF00A735),
                                  ),
                                  label: Text(
                                    "Coba Lagi",
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: const Color(0xFF00A735),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF00A735),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state is MedicalNotesSuccess) {
                          if (state.notes.isEmpty) {
                            return _buildEmptyState(childrenList);
                          }
                          return _buildFilledState(childrenList, state.notes);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  // Bottom Button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.goNamed(AppRoutes.noteAddOrEdit.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A735),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Tambah Catatan Konsultasi",
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<ChildHeaderEntity> childrenList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _buildFilters(childrenList),
        const Expanded(
          child: Center(
            child: NoteEmptyState(
              title: 'Belum ada catatan konsultasi',
              description:
                  'Belum ada hasil konsultasi yang tersimpan. Tambahkan\ncatatan setelah berkonsultasi dengan dokter.',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilledState(
    List<ChildHeaderEntity> childrenList,
    List<MedicalNoteEntity> notes,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _buildFilters(childrenList),
          SizedBox(height: 24.h),
          // Filter Dropdowns
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${notes.length} Catatan',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.grey.shade600,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Note Cards
          ...notes.map((note) {
            return Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
              child: NoteCard(
                id: note.id,
                childName: note.childName,
                date:
                    '${_formatDate(note.createdAt)} - ${_formatDate(note.validUntil)}',
                desc: note.recommendation,
                pantangan: note.prohibitionCount,
                alergi: note.allergyCount,
                isActive: true,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilters(List<ChildHeaderEntity> childrenList) {
    final childItems = ['Semua Anak', ...childrenList.map((e) => e.name)];

    final currentMonthIndex = DateTime.now().month - 1;
    final availableMonths = _months.sublist(currentMonthIndex);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          NoteFilterDropdown(
            text: _selectedChild,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                builder: (context) {
                  return NoteSelectionSheet(
                    title: 'Pilih Anak',
                    items: childItems,
                    selectedValue: _selectedChild,
                    onSelected: (val) {
                      setState(() => _selectedChild = val);
                      _fetchNotes();
                    },
                  );
                },
              );
            },
          ),
          SizedBox(width: 8.w),
          NoteFilterDropdown(
            text: _selectedMonth,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                builder: (context) {
                  return NoteSelectionSheet(
                    title: 'Pilih Bulan',
                    items: availableMonths,
                    selectedValue: _selectedMonth,
                    onSelected: (val) {
                      setState(() => _selectedMonth = val);
                      _fetchNotes();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
