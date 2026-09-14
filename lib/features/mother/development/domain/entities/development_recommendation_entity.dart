import 'package:equatable/equatable.dart';

class DevelopmentRecommendationEntity extends Equatable {
  final String developmentalDomain;
  final String actionText;

  const DevelopmentRecommendationEntity({
    required this.developmentalDomain,
    required this.actionText,
  });

  @override
  List<Object?> get props => [developmentalDomain, actionText];
}
