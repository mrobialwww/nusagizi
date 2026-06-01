import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final String role;
  const OnboardingSuccess({required this.role});

  @override
  List<Object> get props => [role];
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError({required this.message});

  @override
  List<Object> get props => [message];
}
