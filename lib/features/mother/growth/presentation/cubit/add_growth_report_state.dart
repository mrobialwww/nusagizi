import 'package:equatable/equatable.dart';

abstract class AddGrowthReportState extends Equatable {
  const AddGrowthReportState();

  @override
  List<Object?> get props => [];
}

class AddGrowthReportInitial extends AddGrowthReportState {}

class AddGrowthReportLoading extends AddGrowthReportState {}

class AddGrowthReportSuccess extends AddGrowthReportState {
  final String reportId;

  const AddGrowthReportSuccess(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class AddGrowthReportError extends AddGrowthReportState {
  final String message;

  const AddGrowthReportError(this.message);

  @override
  List<Object?> get props => [message];
}
