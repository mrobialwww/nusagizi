import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/features/mother/development/data/models/kpsp_request_model.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_assessment_cubit.dart';
import 'package:nusagizi/features/mother/development/presentation/cubit/kpsp_assessment_state.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/core/utils/age_parser.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';

class KpspAssessmentPage extends StatefulWidget {
  final String childName;
  final String childAge;
  final String childId;
  final String? existingReportId;

  const KpspAssessmentPage({
    super.key,
    required this.childName,
    required this.childAge,
    required this.childId,
    this.existingReportId,
  });

  @override
  State<KpspAssessmentPage> createState() => _KpspAssessmentPageState();
}

class _KpspAssessmentPageState extends State<KpspAssessmentPage> {
  static const Color _green = Color(0xFF00A735);
  static const List<int> _kpspPeriods = [
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

  late final PageController _pageController;
  List<KpspQuestion> _questions = [];
  final List<bool?> _answers = <bool?>[];
  int _currentIndex = 0;

  int _parseMonthTarget(String age) {
    final months = parseAgeToMonths(age);
    return _kpspPeriods.lastWhere(
      (p) => p <= months,
      orElse: () => _kpspPeriods.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onAnswer(bool answer, KpspAssessmentCubit cubit) async {
    setState(() {
      _answers[_currentIndex] = answer;
    });

    if (_currentIndex < _questions.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
      });
    } else {
      // Semua soal selesai → submit
      if (!mounted) return;
      if (widget.existingReportId == null) {
        // CREATE
        final listAnswer = <KpspAnswerRequestModel>[];
        for (int i = 0; i < _questions.length; i++) {
          listAnswer.add(
            KpspAnswerRequestModel(
              questionId: _questions[i].id,
              answer: _answers[i]!,
            ),
          );
        }
        final request = DevelopmentReportCreateRequestModel(
          childId: widget.childId,
          monthTarget: _parseMonthTarget(widget.childAge),
          listAnswer: listAnswer,
        );
        cubit.submitAssessment(request: request);
      } else {
        // UPDATE (retake)
        final listAnswer = <KpspAnswerRequestModel>[];
        for (int i = 0; i < _questions.length; i++) {
          listAnswer.add(
            KpspAnswerRequestModel(
              questionId: _questions[i].id,
              answer: _answers[i]!,
            ),
          );
        }
        cubit.retakeAssessment(
          childId: widget.childId,
          reportId: widget.existingReportId!,
          listAnswer: listAnswer,
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Keluar dari Asesmen?',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          'Progress Anda akan hilang jika keluar sekarang.',
          style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.outfit(
                color: _green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Keluar',
              style: GoogleFonts.outfit(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return exit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<KpspAssessmentCubit>()
            ..loadQuestions(_parseMonthTarget(widget.childAge)),
      child: BlocConsumer<KpspAssessmentCubit, KpspAssessmentState>(
        listener: (context, state) {
          if (state is KpspAssessmentSubmitSuccess) {
            crudFlag = true;
            context.pushReplacementNamed(
              AppRoutes.developmentKpspResult.name,
              extra: KpspResultExtra(
                childName: widget.childName,
                childAge: widget.childAge,
                reportId: state.reportId,
                childId: widget.childId,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<KpspAssessmentCubit>();
          if (state is KpspAssessmentLoaded) {
            _questions = state.questions;
            // Ensure answers list matches questions count
            if (_answers.length != _questions.length) {
              _answers.clear();
              _answers.addAll(List.filled(_questions.length, null));
            }
          }

          if (state is KpspAssessmentError) {
            if (state.questionsFallback != null) {
              _questions = state.questionsFallback!;
            }
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (await _onWillPop()) {
                if (context.mounted) context.pop();
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: HeaderBasic(
                backgroundColor: Colors.white,
                title: 'Asesmen KPSP',
                subtitle: widget.childAge,
                centerTitle: false,
                onBackPressed: () async {
                  if (await _onWillPop()) {
                    if (context.mounted) context.pop();
                  }
                },
                actions: [
                  GestureDetector(
                    onTap: () async {
                      if (await _onWillPop()) {
                        if (context.mounted) context.pop();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Keluar',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    _buildProgressBar(),
                    Expanded(child: _buildBody(cubit, state)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(KpspAssessmentCubit cubit, KpspAssessmentState state) {
    if (state is KpspAssessmentLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00A735)),
      );
    }
    if (state is KpspAssessmentError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.message,
                style: GoogleFonts.outfit(color: Colors.red, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () =>
                    cubit.loadQuestions(_parseMonthTarget(widget.childAge)),
                child: Text('Coba Lagi', style: GoogleFonts.outfit()),
              ),
            ],
          ),
        ),
      );
    }
    if (_questions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00A735)),
      );
    }

    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return _buildQuestionCard(cubit, _questions[index], index);
      },
    );
  }

  Widget _buildProgressBar() {
    String domainLabel(String domain) {
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

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 12.h),
          child: Row(
            children: [
              Text(
                'Pertanyaan ${_currentIndex + 1}/${_questions.length}',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _questions.isNotEmpty
                      ? domainLabel(_questions[_currentIndex].domain)
                      : '',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0,
            end: _questions.isEmpty
                ? 0
                : (_currentIndex + 1) / _questions.length,
          ),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00A735),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard(
    KpspAssessmentCubit cubit,
    KpspQuestion question,
    int index,
  ) {
    final safeProvider = ImageHelper.getSafeImageProvider(question.imageUrl);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Teks Pertanyaan
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                  child: Text(
                    question.question.replaceAll('[nama]', widget.childName),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                // Gambar ilustrasi
                if (safeProvider != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image(
                        image: safeProvider,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackImage(index),
                      ),
                    ),
                  ),
                // Hint / Petunjuk
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Tombol Ya
          _buildAnswerButton(
            label: 'Ya, ${widget.childName} Bisa',
            onTap: () => _onAnswer(true, cubit),
          ),
          SizedBox(height: 10.h),
          // Tombol Belum
          _buildAnswerButton(
            label: 'Belum Bisa',
            onTap: () => _onAnswer(false, cubit),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildAnswerButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFF00A735), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF00A735),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 12.sp, color: Colors.white),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage(int index) {
    final assetIndex = (index % 4) + 1;
    String assetPath;
    switch (assetIndex) {
      case 1:
        assetPath = AppImages.asesment1;
        break;
      case 2:
        assetPath = AppImages.asesment2;
        break;
      case 3:
        assetPath = AppImages.asesment3;
        break;
      case 4:
      default:
        assetPath = AppImages.asesment4;
        break;
    }

    return Container(
      height: 200,
      width: double.infinity,
      color: const Color(0xFFF0F0F0),
      child: Image.asset(assetPath, fit: BoxFit.cover),
    );
  }
}
