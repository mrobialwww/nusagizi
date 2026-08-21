import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';

abstract class GrowthHistoryState extends Equatable {
  const GrowthHistoryState();

  @override
  List<Object> get props => [];
}

class GrowthHistoryInitial extends GrowthHistoryState {}

class GrowthHistoryLoading extends GrowthHistoryState {}

class GrowthHistoryLoaded extends GrowthHistoryState {
  final List<LatestGrowthReportEntity> history;

  const GrowthHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class GrowthHistoryError extends GrowthHistoryState {
  final String message;

  const GrowthHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
