import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/development/domain/entities/child_development_report_detail_entity.dart';

abstract class KpspResultState extends Equatable {
  const KpspResultState();

  @override
  List<Object?> get props => [];
}

class KpspResultInitial extends KpspResultState {}

class KpspResultLoading extends KpspResultState {}

class KpspResultLoaded extends KpspResultState {
  final ChildDevelopmentReportDetailEntity detail;

  const KpspResultLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class KpspResultError extends KpspResultState {
  final String message;

  const KpspResultError(this.message);

  @override
  List<Object?> get props => [message];
}
