import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_radar_chart.dart';

class DevelopmentProfileCard extends StatelessWidget {
  final String childName;
  final String childAge;
  final String childId;
  final String reportId;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;

  const DevelopmentProfileCard({
    super.key,
    required this.childName,
    required this.childAge,
    required this.childId,
    required this.reportId,
    required this.motorikHalus,
    required this.motorikKasar,
    required this.sosialisasi,
    required this.bicara,
  });

  static const Color _accentColor = Color(0xFF00A735);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed(
                AppRoutes.developmentProfileDetail.name,
                extra: DevelopmentProfileDetailExtra(
                  childName: childName,
                  childAge: childAge,
                  childId: childId,
                  reportId: reportId,
                  motorikHalus: motorikHalus,
                  motorikKasar: motorikKasar,
                  sosialisasi: sosialisasi,
                  bicara: bicara,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Perkembangan',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Berdasarkan asesmen terakhir',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          DevelopmentRadarChart(
            motorikHalus: motorikHalus,
            motorikKasar: motorikKasar,
            sosialisasi: sosialisasi,
            bicara: bicara,
            color: _accentColor,
            height: 220,
            tickCount: 4,
            borderWidth: 1.5,
            radarBorderColor: Colors.transparent,
            gridBorderColor: Colors.grey.withValues(alpha: 0.3),
            titleTextStyle: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 30.h),
          // Legend
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Motorik Kasar', motorikKasar),
                    SizedBox(height: 10.h),
                    _legendItem('Bicara & Bahasa', bicara),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Motorik Halus', motorikHalus),
                    SizedBox(height: 10.h),
                    _legendItem('Sosialisasi', sosialisasi),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusFromScore(double score) {
    if (score >= 1.0) return "Sesuai Usia";
    if (score >= 0.66) return "Perlu Stimulasi";
    if (score >= 0.5) return "Perkembangan meragukan";
    if (score >= 0.33) return "Perlu Evaluasi";
    return "Kemungkinan penyimpangan";
  }

  Widget _legendItem(String label, double score) {
    final status = _statusFromScore(score);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(
            top: 4.h,
          ), // align dot with first line of text
          decoration: const BoxDecoration(
            color: _accentColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label ',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: '($status)',
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
        ),
      ],
    );
  }
}
