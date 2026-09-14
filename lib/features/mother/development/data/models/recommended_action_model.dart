import 'package:nusagizi/features/mother/development/domain/entities/recommended_action_entity.dart';

class RecommendedActionModel extends RecommendedActionEntity {
  const RecommendedActionModel({
    required super.id,
    required super.title,
    required super.actionText,
  });

  factory RecommendedActionModel.fromJson(Map<String, dynamic> json) {
    return RecommendedActionModel(
      id: json['recommended_action_id'] as String,
      title: json['title'] as String,
      actionText: json['action_text'] as String,
    );
  }
}
