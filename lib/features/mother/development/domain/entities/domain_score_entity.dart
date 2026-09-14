import 'package:equatable/equatable.dart';

class DomainScoreEntity extends Equatable {
  final String developmentalDomain;
  final int totalQuestion;
  final int trueAnswer;

  const DomainScoreEntity({
    required this.developmentalDomain,
    required this.totalQuestion,
    required this.trueAnswer,
  });

  @override
  List<Object?> get props => [developmentalDomain, totalQuestion, trueAnswer];
}
