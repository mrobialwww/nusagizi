import 'package:nusagizi/features/mother/development/domain/entities/checklist_milestone_task_entity.dart';

class ChecklistMilestoneTaskModel extends ChecklistMilestoneTaskEntity {
  const ChecklistMilestoneTaskModel({
    required super.id,
    required super.developmentalDomain,
    required super.questionText,
    required super.isChecked,
  });

  factory ChecklistMilestoneTaskModel.fromJson(Map<String, dynamic> json) {
    return ChecklistMilestoneTaskModel(
      id: json['id'] as String,
      developmentalDomain: json['developmental_domain'] as String,
      questionText: json['question_text'] as String,
      isChecked: json['is_checked'] as bool,
    );
  }
}
