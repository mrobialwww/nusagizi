import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_alarm_entity.dart';

class CaregiverAlarmModel extends CaregiverAlarmEntity {
  const CaregiverAlarmModel({
    required super.id,
    required super.title,
    required super.hour,
    required super.minute,
    required super.isActive,
  });

  CaregiverAlarmModel copyWith({
    int? id,
    String? title,
    int? hour,
    int? minute,
    bool? isActive,
  }) {
    return CaregiverAlarmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
    );
  }

  factory CaregiverAlarmModel.fromJson(Map<String, dynamic> json) {
    return CaregiverAlarmModel(
      id: json['id'] as int,
      title: json['title'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hour': hour,
      'minute': minute,
      'isActive': isActive,
    };
  }
}
