import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/constants/kpsp_dummy_data.dart';
import 'package:nusagizi/features/mother/development/domain/entities/kpsp_question.dart';
import 'package:nusagizi/core/routes/route_args.dart';
import 'package:nusagizi/router.dart';

class KpspAssessmentPage extends StatefulWidget {
  final String childName;
  final String childAge;

  const KpspAssessmentPage({
    super.key,
    required this.childName,
    required this.childAge,
  });

  @override
  State<KpspAssessmentPage> createState() => _KpspAssessmentPageState();
}

class _KpspAssessmentPageState extends State<KpspAssessmentPage> {
  static const Color _green = Color(0xFF3CB648);

  late final PageController _pageController;
  final List<KpspQuestion> _questions = kpspDummyQuestions;
  final List<bool?> _answers = List.filled(10, null);
  int _currentIndex = 0;

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

  /// Ganti placeholder [nama] dengan nama anak sebenarnya
  String _replaceChildName(String text) {
    return text.replaceAll('[nama]', widget.childName);
  }

  Future<void> _onAnswer(bool answer) async {
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
      // Semua soal selesai → ke halaman hasil
      if (!mounted) return;
      context.pushReplacementNamed(
        AppRoutes.developmentKpspResult.name,
        extra: KpspResultExtra(
          childName: widget.childName,
          childAge: widget.childAge,
          questions: _questions,
          answers: List<bool>.from(_answers.map((a) => a ?? false)),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar dari Asesmen?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Progress Anda akan hilang jika keluar sekarang.',
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildProgressBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(_questions[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (await _onWillPop()) {
                if (context.mounted) context.pop();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              size: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asesmen KPSP',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  widget.childAge,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (await _onWillPop()) {
                if (context.mounted) context.pop();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Keluar',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Text(
                'Pertanyaan ${_currentIndex + 1}/${_questions.length}',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _questions[_currentIndex].domain.label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: (_currentIndex + 1) / _questions.length),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3CB648),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard(KpspQuestion question, int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Teks Pertanyaan
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    _replaceChildName(question.question),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                // Gambar ilustrasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      question.imagePath,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: const Color(0xFFF0F0F0),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.black26,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                // Hint / Petunjuk
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Text(
                    _replaceChildName(question.hint),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tombol Ya
          _buildAnswerButton(
            label: 'Ya, ${widget.childName} Bisa',
            onTap: () => _onAnswer(true),
          ),
          const SizedBox(height: 10),
          // Tombol Belum
          _buildAnswerButton(
            label: 'Belum Bisa',
            onTap: () => _onAnswer(false),
          ),
          const SizedBox(height: 24),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3CB648), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                color: Color(0xFF3CB648),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
