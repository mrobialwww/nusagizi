import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';

class DevelopmentRecommendationModel extends DevelopmentRecommendationEntity {
  const DevelopmentRecommendationModel({
    required super.developmentalDomain,
    required super.actionText,
  });

  factory DevelopmentRecommendationModel.fromJson(Map<String, dynamic> json) {
    return DevelopmentRecommendationModel(
      developmentalDomain: json['developmental_domain'] as String,
      actionText: json['action_text'] as String,
    );
  }
}
