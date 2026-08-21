import 'package:nusagizi/core/utils/date_formatter.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_summary_entity.dart';

class ChildDevelopmentSummaryModel extends ChildDevelopmentSummaryEntity {
  const ChildDevelopmentSummaryModel({
    required super.id,
    required super.badgeStatus,
    required super.lastCheck,
    required super.kpspScore,
    required super.kpspTotal,
    required super.nextCheck,
    super.nextCheckDate,
    required super.motorikHalus,
    required super.motorikKasar,
    required super.sosialisasi,
    required super.bicara,
  });

  factory ChildDevelopmentSummaryModel.fromJson(Map<String, dynamic> json) {
    final domains =
        (json['domains'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    double domainScore(String name) {
      final d = domains.firstWhere(
        (d) => d['developmental_domain'] == name,
        orElse: () => {'total_question': 1, 'true_answer': 0},
      );
      final total = d['total_question'] as int;
      final correct = d['true_answer'] as int;
      return total == 0 ? 0.0 : correct / total;
    }

    final nextCheckRaw = json['next_check_date'] as String;
    final isDone = nextCheckRaw == 'done';

    return ChildDevelopmentSummaryModel(
      id: json['id'] as String,
      badgeStatus: json['status'] as String,
      lastCheck: AppDateFormatter.formatIndonesian(
        json['created_at'] as String,
      ),
      kpspScore: json['kpsp_score'] as int,
      kpspTotal: json['kpsp_answers_count'] as int? ?? 10,
      nextCheck: isDone
          ? 'Selesai'
          : AppDateFormatter.formatIndonesian(nextCheckRaw),
      nextCheckDate: isDone ? null : AppDateFormatter.parseDate(nextCheckRaw),
      motorikKasar: domainScore('gross_motor_skills'),
      motorikHalus: domainScore('fine_motor_skills'),
      sosialisasi: domainScore('socialization'),
      bicara: domainScore('speech_and_language'),
    );
  }
}
