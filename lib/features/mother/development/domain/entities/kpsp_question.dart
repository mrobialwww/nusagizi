import 'package:equatable/equatable.dart';

class KpspQuestion extends Equatable {
  const KpspQuestion({
    required this.id,
    required this.domain,
    required this.question,
    required this.monthTarget,
    this.imageUrl,
  });

  final String id;
  final String domain;
  final String question;
  final int monthTarget;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, domain, question, monthTarget, imageUrl];
}
