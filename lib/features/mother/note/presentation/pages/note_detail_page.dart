import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/utils/number_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_note_detail_cubit.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/medical_note_detail_state.dart';
import 'package:nusagizi/router.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _cubit = sl<MedicalNoteDetailCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchMedicalNoteDetail(widget.noteId);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MedicalNoteDetailCubit, MedicalNoteDetailState>(
        builder: (context, state) {
          if (state is MedicalNoteDetailSuccess) {
            final detail = state.detail;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            // Hanya periksa dari sisi tanggal saja, abaikan jam.
            final isExpired = today.isAfter(detail.validDate);
            final formattedValidDate = _formatDate(detail.validDate);
            final formattedCreatedDate = _formatDate(detail.createdAt);

            return Scaffold(
              backgroundColor: const Color(0xFFF9FAFB),
              appBar: HeaderBasic(
                backgroundColor: Colors.white,
                title: detail.childName,
                subtitle: '${detail.doctorName} • $formattedCreatedDate',
                centerTitle: false,
                actions: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 16.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? Colors.grey.shade100
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: isExpired
                                  ? Colors.grey
                                  : const Color(0xFF00A735),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            isExpired ? 'Kadaluwarsa' : 'Aktif',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: isExpired
                                  ? Colors.grey
                                  : const Color(0xFF00A735),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner Status
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? const Color(0xFFFFEBEE)
                                    : const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isExpired
                                      ? const Color(0xFFEF9A9A)
                                      : const Color(0xFF81C784),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isExpired
                                        ? Icons.cancel
                                        : Icons.check_circle,
                                    color: isExpired
                                        ? const Color(0xFFF44336)
                                        : const Color(0xFF00A735),
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isExpired
                                            ? 'Catatan telah kedaluwarsa'
                                            : 'Catatan masih berlaku',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          color: isExpired
                                              ? const Color(0xFFF44336)
                                              : const Color(0xFF00A735),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Berlaku hingga $formattedValidDate.',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          color: isExpired
                                              ? const Color(0xFFE53935)
                                              : const Color(0xFF4CAF50),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Rekomendasi Medis
                            _buildCardSection(
                              title: 'Rekomendasi Medis',
                              child: Text(
                                detail.recommendation,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: Colors.black87,
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Target Gizi Harian
                            if (detail.dailyNutritionTargets.isNotEmpty) ...[
                              _buildCardSection(
                                title: 'Target Gizi Harian',
                                subtitle:
                                    'Kebutuhan nutrisi harian yang direkomendasikan',
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 2.2,
                                  children: detail.dailyNutritionTargets.map((
                                    n,
                                  ) {
                                    final info = _getNutrientInfo(n.nutrient);
                                    return _buildNutritionItem(
                                      icon: info.icon,
                                      iconColor: info.color,
                                      iconBgColor: info.color.withValues(
                                        alpha: 0.08,
                                      ),
                                      label: info.label,
                                      value: n.quantity.toMacroFormat(),
                                      unit: info.unit,
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],

                            // Pantangan & Alergi
                            if (detail.medicalRestrictions.isNotEmpty)
                              _buildCardSection(
                                title: 'Pantangan & Alergi',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (detail.medicalRestrictions.any(
                                      (r) => r.type == 'prohibition',
                                    )) ...[
                                      Text(
                                        'Pantangan, hindari makanan berikut',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          color: Colors.red.shade400,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: detail.medicalRestrictions
                                            .where(
                                              (r) => r.type == 'prohibition',
                                            )
                                            .map(
                                              (r) => _buildChip(
                                                Icons.cancel,
                                                r.restrictionName,
                                                Colors.red,
                                                Colors.red.shade50,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                    if (detail.medicalRestrictions.any(
                                      (r) => r.type == 'allergy',
                                    )) ...[
                                      Text(
                                        'Alergi, perhatikan reaksi tubuh anak',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          color: Colors.orange.shade400,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: detail.medicalRestrictions
                                            .where((r) => r.type == 'allergy')
                                            .map(
                                              (r) => _buildChip(
                                                Icons.info,
                                                r.restrictionName,
                                                Colors.orange,
                                                Colors.orange.shade50,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            // Disclaimer
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'Catatan konsultasi ini hanya dapat dilihat. Untuk mengubah isinya, lakukan pembaruan saat sesi konsultasi berikutnya.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: Colors.black54,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => context.goNamed(
                            AppRoutes.noteAddOrEdit.name,
                            extra: detail,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF00A735)),
                            foregroundColor: const Color(0xFF00A735),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Ubah Catatan",
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
                ),
              ),
            );
          }

          // State Error
          if (state is MedicalNoteDetailError) {
            return Scaffold(
              backgroundColor: const Color(0xFFF9FAFB),
              appBar: const HeaderBasic(
                backgroundColor: Colors.white,
                title: 'Gagal Memuat',
                subtitle: '',
                centerTitle: false,
              ),
              body: Center(
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
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.red.shade400,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _cubit.fetchMedicalNoteDetail(widget.noteId),
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
                        side: const BorderSide(color: Color(0xFF00A735)),
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
              ),
            );
          }

          // State Loading / Initial (Satu layar penuh loading)
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Color(0xFF00A735)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.black54,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildNutritionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.black54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.black87,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      unit,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.black38,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  ({IconData icon, Color color, String label, String unit}) _getNutrientInfo(
    String nutrient,
  ) => switch (nutrient.toLowerCase()) {
    'calorie' => (
      icon: Icons.local_fire_department,
      color: Colors.red,
      label: 'Kalori',
      unit: 'kcal/hari',
    ),
    'protein' => (
      icon: Icons.egg_alt,
      color: Colors.orange,
      label: 'Protein',
      unit: 'g/hari',
    ),
    'fat' => (
      icon: Icons.water_drop,
      color: Colors.green,
      label: 'Lemak',
      unit: 'g/hari',
    ),
    'carbohydrate' => (
      icon: Icons.grain,
      color: Colors.blue,
      label: 'Karbohidrat',
      unit: 'g/hari',
    ),
    _ => (
      icon: Icons.grain,
      color: Colors.grey,
      label: nutrient,
      unit: 'g/hari',
    ),
  };
}
