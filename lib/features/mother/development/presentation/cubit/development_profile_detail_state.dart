import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/development/domain/entities/development_recommendation_entity.dart';

abstract class DevelopmentProfileDetailState extends Equatable {
  const DevelopmentProfileDetailState();

  @override
  List<Object?> get props => [];
}

class DevelopmentProfileDetailInitial extends DevelopmentProfileDetailState {}

class DevelopmentProfileDetailLoading extends DevelopmentProfileDetailState {}

class DevelopmentProfileDetailLoaded extends DevelopmentProfileDetailState {
  final List<DevelopmentRecommendationEntity> recommendations;

  const DevelopmentProfileDetailLoaded(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class DevelopmentProfileDetailError extends DevelopmentProfileDetailState {
  final String message;

  const DevelopmentProfileDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
