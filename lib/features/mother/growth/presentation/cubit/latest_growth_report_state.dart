import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/latest_growth_report_entity.dart';

abstract class LatestGrowthReportState extends Equatable {
  const LatestGrowthReportState();

  @override
  List<Object?> get props => [];
}

class LatestGrowthReportInitial extends LatestGrowthReportState {}

class LatestGrowthReportLoading extends LatestGrowthReportState {}

class LatestGrowthReportSuccess extends LatestGrowthReportState {
  final LatestGrowthReportEntity data;

  const LatestGrowthReportSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class LatestGrowthReportError extends LatestGrowthReportState {
  final String message;

  const LatestGrowthReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
