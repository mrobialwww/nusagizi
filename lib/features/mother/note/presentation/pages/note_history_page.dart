import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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

class NoteHistoryPage extends StatefulWidget {
  const NoteHistoryPage({super.key});

  @override
  State<NoteHistoryPage> createState() => _NoteHistoryPageState();
}

class _NoteHistoryPageState extends State<NoteHistoryPage> {
  String _selectedChild = 'Semua Anak';
  late String _selectedMonth;
  late final MedicalNotesCubit _notesCubit;

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months[DateTime.now().month - 1];
    _notesCubit = sl<MedicalNotesCubit>();
    _fetchNotes();
  }

  void _fetchNotes() {
    _notesCubit.fetchMedicalNotes(
      status: 'history',
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
      appBar: const HeaderBasic(
        backgroundColor: Colors.white,
        title: 'Riwayat Catatan',
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
                            child: Text(
                              state.message,
                              style: GoogleFonts.outfit(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
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
              title: 'Belum ada riwayat konsultasi',
              description:
                  'Catatan konsultasi yang telah berakhir masa berlakunya\nakan otomatis tersimpan di sini sebagai riwayat.',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${notes.length} Catatan',
              style: GoogleFonts.outfit(
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
                date: '${_formatDate(note.createdAt)} - ${_formatDate(note.validUntil)}',
                desc: note.recommendation,
                pantangan: note.prohibitionCount,
                alergi: note.allergyCount,
                isActive: false,
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
    // Tampilkan dari Januari hingga bulan saat ini (inklusif)
    final availableMonths = _months.sublist(0, currentMonthIndex + 1);

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
