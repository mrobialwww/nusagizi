import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';

abstract class GrowthAnalysesState extends Equatable {
  const GrowthAnalysesState();

  @override
  List<Object?> get props => [];
}

class GrowthAnalysesInitial extends GrowthAnalysesState {}

class GrowthAnalysesLoading extends GrowthAnalysesState {}

class GrowthAnalysesLoaded extends GrowthAnalysesState {
  final GrowthAnalysesEntity data;

  const GrowthAnalysesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class GrowthAnalysesError extends GrowthAnalysesState {
  final String message;

  const GrowthAnalysesError(this.message);

  @override
  List<Object?> get props => [message];
}
