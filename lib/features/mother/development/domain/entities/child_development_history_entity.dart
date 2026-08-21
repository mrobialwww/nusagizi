import 'package:equatable/equatable.dart';

class ChildDevelopmentHistoryEntity extends Equatable {
  final String id;
  final int kpspScore;
  final int monthTarget;
  final String status;
  final DateTime createdAt;

  const ChildDevelopmentHistoryEntity({
    required this.id,
    required this.kpspScore,
    required this.monthTarget,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, kpspScore, monthTarget, status, createdAt];
}
