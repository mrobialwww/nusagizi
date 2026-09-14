import 'package:equatable/equatable.dart';

class ChecklistMilestoneTaskEntity extends Equatable {
  const ChecklistMilestoneTaskEntity({
    required this.id,
    required this.developmentalDomain,
    required this.questionText,
    required this.isChecked,
  });

  final String id;
  final String developmentalDomain;
  final String questionText;
  final bool isChecked;

  ChecklistMilestoneTaskEntity copyWith({bool? isChecked}) {
    return ChecklistMilestoneTaskEntity(
      id: id,
      developmentalDomain: developmentalDomain,
      questionText: questionText,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<Object?> get props => [id, developmentalDomain, questionText, isChecked];
}
