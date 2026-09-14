import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_result_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_result_state.dart';

class KpspResultPage extends StatelessWidget {
  final String childName;
  final String childAge;
  final String reportId;
  final bool isFromHistory;
  final String childId;
  final bool showRetakeButton;

  const KpspResultPage({
    super.key,
    required this.childName,
    required this.childAge,
    required this.reportId,
    this.isFromHistory = false,
    required this.childId,
    this.showRetakeButton = true,
  });

  static const Color _green = Color(0xFF00A735);
  static const Color _lightGreen = Color(0xFFDDEFDD);

  IconData _getIconForDomain(String domain) {
    if (domain.toLowerCase().contains('motor')) {
      if (domain.toLowerCase().contains('gross') ||
          domain.toLowerCase().contains('kasar')) {
        return Icons.directions_run_rounded;
      }
      return Icons.draw_rounded;
    }
    if (domain.toLowerCase().contains('speech') ||
        domain.toLowerCase().contains('bicara')) {
      return Icons.record_voice_over_rounded;
    }
    return Icons.people_alt_rounded;
  }

  Color _statusColor(String apiStatus) {
    if (apiStatus.toLowerCase().contains('sesuai usia')) return _green;
    if (apiStatus.toLowerCase().contains('meragukan')) {
      return const Color(0xFFFF9800);
    }
    return const Color(0xFFE53935);
  }

  Color _statusBgColor(String apiStatus) {
    if (apiStatus.toLowerCase().contains('sesuai usia')) return _lightGreen;
    if (apiStatus.toLowerCase().contains('meragukan')) {
      return const Color(0xFFFFEBD6);
    }
    return const Color(0xFFFFEBEE);
  }

  String _mapDomainName(String domain) {
    if (domain.toLowerCase().contains('gross')) return 'Motorik Kasar';
    if (domain.toLowerCase().contains('fine')) return 'Motorik Halus';
    if (domain.toLowerCase().contains('speech')) return 'Bicara & Bahasa';
    if (domain.toLowerCase().contains('social')) return 'Sosialisasi';
    return domain;
  }

  String _summaryTitle(String apiStatus) {
    if (apiStatus.toLowerCase().contains('sesuai usia')) {
      return 'Perkembangan Sangat Baik';
    }
    if (apiStatus.toLowerCase().contains('meragukan')) {
      return 'Perkembangan Meragukan';
    }
    return 'Perkembangan Menyimpang';
  }

  String _summaryDesc(String apiStatus) {
    if (apiStatus.toLowerCase().contains('sesuai usia')) {
      return 'Hebat! Perkembangan $childName saat ini sesuai dengan tahap umurnya. Terus berikan stimulasi yang menyenangkan ya Bunda.';
    }
    if (apiStatus.toLowerCase().contains('meragukan')) {
      return 'Perkembangan $childName perlu dipantau lebih lanjut. Coba lakukan stimulasi di area yang belum optimal.';
    }
    return 'Perkembangan $childName memerlukan perhatian khusus. Segera konsultasikan dengan tenaga kesehatan.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KpspResultCubit>()..loadDetail(reportId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: HeaderBasic(
          backgroundColor: Colors.white,
          title: 'Hasil Asesmen KPSP',
          subtitle: childAge,
          centerTitle: false,
          onBackPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(AppRoutes.development.name);
            }
          },
          actions: [
            GestureDetector(
              onTap: () {
                // TODO: Implementasi share
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share_outlined,
                  size: 18.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<KpspResultCubit, KpspResultState>(
            builder: (context, state) {
              if (state is KpspResultLoading || state is KpspResultInitial) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00A735)));
              }
              if (state is KpspResultError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      state.message,
                      style: GoogleFonts.outfit(
                        color: Colors.red,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (state is KpspResultLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            _buildSummaryCard(state.detail),
                            SizedBox(height: 16.h),
                            _buildDomainCard(context, state.detail),
                            SizedBox(height: 16.h),
                            _buildRecommendationCard(state.detail),
                            SizedBox(height: 24.h),
                            _buildSaveButton(context, state.detail),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ChildDevelopmentReportDetailEntity detail) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: _statusBgColor(detail.status),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _statusColor(detail.status).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: _statusColor(detail.status),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 14.sp, color: Colors.white),
                SizedBox(width: 4.w),
                Text(
                  detail.status,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${detail.kpspScore}',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 52.sp,
                    color: Colors.black87,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: '/${detail.kpspAnswersCount}',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _summaryTitle(detail.status),
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            _summaryDesc(detail.status),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainCard(
    BuildContext context,
    ChildDevelopmentReportDetailEntity detail,
  ) {
    if (detail.domains.isEmpty) return const SizedBox();
    return Container(
      padding: EdgeInsets.all(20.w),
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
          Row(
            children: [
              Icon(Icons.pie_chart, size: 24.sp, color: _green),
              SizedBox(width: 8.w),
              Text(
                'Rincian Domain',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: detail.domains.map((d) {
              final isGood =
                  d.totalQuestion > 0 && d.trueAnswer == d.totalQuestion;
              return _buildDomainScoreItem(
                context: context,
                domainLabel: d.developmentalDomain,
                score: d.trueAnswer,
                total: d.totalQuestion,
                isGood: isGood,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainScoreItem({
    required BuildContext context,
    required String domainLabel,
    required int score,
    required int total,
    required bool isGood,
  }) {
    final itemWidth = (MediaQuery.of(context).size.width - 72 - 12) / 2;
    return Container(
      width: itemWidth,
      constraints: const BoxConstraints(minHeight: 90),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isGood ? const Color(0xFFDDEFDD) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForDomain(domainLabel),
              size: 20.sp,
              color: isGood ? _green : Colors.black45,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _mapDomainName(domainLabel),
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '$score/$total',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(ChildDevelopmentReportDetailEntity detail) {
    if (detail.recommendedActions.isEmpty) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(20.w),
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
          Row(
            children: [
              Icon(Icons.assignment, size: 24.sp, color: _green),
              SizedBox(width: 8.w),
              Text(
                'Rekomendasi Selanjutnya',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...detail.recommendedActions.map((rec) {
            final isLast = rec == detail.recommendedActions.last;
            final icon = isLast
                ? Icons.calendar_month_outlined
                : Icons.extension;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDEFDD),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 20.sp, color: _green),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: const Color(0xFFE0E0E0),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              rec.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                            if (rec.actionText.isNotEmpty) ...[
                              SizedBox(height: 6.h),
                              Text(
                                rec.actionText,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  double _domainScore(
    ChildDevelopmentReportDetailEntity detail,
    String domainName,
  ) {
    final d = detail.domains.where((d) => d.developmentalDomain == domainName);
    if (d.isEmpty) return 0.0;
    final score = d.first;
    return score.totalQuestion == 0
        ? 0.0
        : score.trueAnswer / score.totalQuestion;
  }

  Widget _buildSaveButton(
    BuildContext context,
    ChildDevelopmentReportDetailEntity detail,
  ) {
    final hasRetakeButton = showRetakeButton;

    void navigateToProfile() {
      context.pushNamed(
        AppRoutes.developmentProfileDetail.name,
        extra: DevelopmentProfileDetailExtra(
          childName: childName,
          childAge: childAge,
          childId: childId,
          reportId: reportId,
          motorikHalus: _domainScore(detail, 'fine_motor_skills'),
          motorikKasar: _domainScore(detail, 'gross_motor_skills'),
          sosialisasi: _domainScore(detail, 'socialization'),
          bicara: _domainScore(detail, 'speech_and_language'),
        ),
      );
    }

    if (!hasRetakeButton) {
      return _buildProfilPerkembanganButton(
        context,
        isFullWidth: true,
        onTap: navigateToProfile,
      );
    }

    if (isFromHistory) {
      return Row(
        children: [
          Expanded(
            child: _buildUlangiAsesmenButton(context, isFullWidth: false),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildProfilPerkembanganButton(
              context,
              isFullWidth: false,
              onTap: navigateToProfile,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildUlangiAsesmenButton(context, isFullWidth: false),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildProfilPerkembanganButton(
                context,
                isFullWidth: false,
                onTap: navigateToProfile,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              context.goNamed(AppRoutes.development.name);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Selesai',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUlangiAsesmenButton(
    BuildContext context, {
    required bool isFullWidth,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushReplacementNamed(
          AppRoutes.developmentKpsp.name,
          extra: KpspAssessmentExtra(
            childName: childName,
            childAge: childAge,
            childId: childId,
            existingReportId: reportId,
          ),
        );
      },
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: _green, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Ulangi Asesmen',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            color: _green,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilPerkembanganButton(
    BuildContext context, {
    required bool isFullWidth,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: _green,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Profil Perkembangan',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
