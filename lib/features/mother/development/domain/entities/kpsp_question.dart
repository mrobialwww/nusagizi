import 'kpsp_domain.dart';

class KpspQuestion {
  final int id;
  final KpspDomain domain;
  final String question;
  final String hint;
  final String imagePath;

  const KpspQuestion({
    required this.id,
    required this.domain,
    required this.question,
    required this.hint,
    required this.imagePath,
  });

  /// Factory untuk membuat instance dari Map JSON (siap untuk integrasi API)
  factory KpspQuestion.fromJson(Map<String, dynamic> json) {
    return KpspQuestion(
      id: json['id'] as int,
      domain: KpspDomain.values.firstWhere(
        (d) => d.label == json['domain'],
        orElse: () => KpspDomain.motorikKasar,
      ),
      question: json['question'] as String,
      hint: json['hint'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain.label,
      'question': question,
      'hint': hint,
      'imagePath': imagePath,
    };
  }
}
