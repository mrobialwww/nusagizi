import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_profile_detail_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/development_profile_detail_state.dart';
import 'package:nusagizi/features/mother/development/presentation/widgets/development_radar_chart.dart';

class DevelopmentProfileDetailPage extends StatelessWidget {
  final String childName;
  final String childAge;
  final String childId;
  final String reportId;
  final double motorikHalus;
  final double motorikKasar;
  final double sosialisasi;
  final double bicara;

  const DevelopmentProfileDetailPage({
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

  static const Color _green = Color(0xFF00A735);
  static const Color _bg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<DevelopmentProfileDetailCubit>()
            ..loadRecommendations(childId: childId, reportId: reportId),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: HeaderBasic(
          backgroundColor: _bg,
          title: 'Profil Perkembangan',
          subtitle: childAge,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadarChartCard(),
              SizedBox(height: 24.h),
              Text(
                'Detail Domain',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 12.h),
              _buildDetailList(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadarChartCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          Text(
            'Ringkasan Domain',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Skor perkembangan anak bulan ini',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 24.h),
          DevelopmentRadarChart(
            motorikHalus: motorikHalus * 100,
            motorikKasar: motorikKasar * 100,
            sosialisasi: sosialisasi * 100,
            bicara: bicara * 100,
            color: _green,
          ),
        ],
      ),
    );
  }

  (Color, Color) _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('sesuai')) {
      return (const Color(0xFFDDEFDD), _green);
    } else if (s.contains('stimulasi')) {
      return (const Color(0xFFFFF4CC), const Color(0xFFD9A000));
    } else if (s.contains('meragukan')) {
      return (const Color(0xFFFFE5D9), const Color(0xFFF26E22));
    } else if (s.contains('evaluasi')) {
      return (const Color(0xFFFFEAE6), const Color(0xFFF4511E));
    } else {
      return (const Color(0xFFFFDDE5), const Color(0xFFE53935));
    }
  }

  String _statusFromScore(double score) {
    if (score >= 1.0) return "Sesuai Usia";
    if (score >= 0.66) return "Perlu Stimulasi";
    if (score >= 0.5) return "Perkembangan meragukan";
    if (score >= 0.33) return "Perlu Evaluasi";
    return "Kemungkinan penyimpangan";
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
        return 'Sosialisasi';
      default:
        return domain;
    }
  }

  IconData _domainIcon(String domain) {
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
        return Icons.help_outline;
    }
  }

  Widget _buildDetailList() {
    final domains = [
      ('gross_motor_skills', motorikKasar),
      ('fine_motor_skills', motorikHalus),
      ('speech_and_language', bicara),
      ('socialization', sosialisasi),
    ];

    return BlocBuilder<
      DevelopmentProfileDetailCubit,
      DevelopmentProfileDetailState
    >(
      builder: (context, state) {
        final recommendations = state is DevelopmentProfileDetailLoaded
            ? state.recommendations
            : <DevelopmentRecommendationEntity>[];

        String? findActionText(String domainKey) {
          for (final rec in recommendations) {
            if (rec.developmentalDomain == domainKey) {
              return rec.actionText;
            }
          }
          return null;
        }

        return Column(
          children: domains.map((entry) {
            final (domain, value) = entry;
            final status = _statusFromScore(value);
            final percentage = value * 100;
            final (bgColor, textColor) = _getStatusColor(status);
            final icon = _domainIcon(domain);
            final actionText = findActionText(domain);

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 20.sp, color: _green),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _domainLabel(domain),
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${percentage.toInt()}% Tercapai',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (actionText != null) ...[
                    SizedBox(height: 12.h),
                    Text(
                      actionText,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
