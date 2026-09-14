import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';

abstract class MotherHomeState extends Equatable {
  const MotherHomeState();

  @override
  List<Object?> get props => [];
}

class MotherHomeInitial extends MotherHomeState {}

class MotherHomeLoading extends MotherHomeState {}

class MotherHomeLoaded extends MotherHomeState {
  final List<ChildSummaryEntity> children;

  const MotherHomeLoaded({required this.children});

  @override
  List<Object?> get props => [children];
}

class MotherHomeError extends MotherHomeState {
  final String message;

  const MotherHomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
