import 'package:equatable/equatable.dart';

class RecommendedActionEntity extends Equatable {
  final String id;
  final String title;
  final String actionText;

  const RecommendedActionEntity({
    required this.id,
    required this.title,
    required this.actionText,
  });

  @override
  List<Object?> get props => [id, title, actionText];
}
