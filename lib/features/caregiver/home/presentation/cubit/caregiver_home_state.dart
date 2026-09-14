import 'package:equatable/equatable.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';

abstract class CaregiverHomeState extends Equatable {
  const CaregiverHomeState();

  @override
  List<Object> get props => [];
}

class CaregiverHomeInitial extends CaregiverHomeState {}

class CaregiverHomeLoading extends CaregiverHomeState {}

class CaregiverHomeLoaded extends CaregiverHomeState {
  final List<ChildHeaderEntity> children;

  const CaregiverHomeLoaded({required this.children});

  @override
  List<Object> get props => [children];
}

class CaregiverHomeError extends CaregiverHomeState {
  final String message;

  const CaregiverHomeError({required this.message});

  @override
  List<Object> get props => [message];
}
