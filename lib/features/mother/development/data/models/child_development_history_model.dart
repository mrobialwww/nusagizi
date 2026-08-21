import 'package:nusagizi/features/mother/development/domain/entities/child_development_history_entity.dart';

class ChildDevelopmentHistoryModel extends ChildDevelopmentHistoryEntity {
  const ChildDevelopmentHistoryModel({
    required super.id,
    required super.kpspScore,
    required super.monthTarget,
    required super.status,
    required super.createdAt,
  });

  factory ChildDevelopmentHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChildDevelopmentHistoryModel(
      id: json['id'] as String,
      kpspScore: json['kpsp_score'] as int,
      monthTarget: json['month_target'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
