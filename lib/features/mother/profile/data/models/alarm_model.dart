import 'package:nusagizi/features/mother/profile/domain/entities/alarm_entity.dart';

class AlarmModel extends AlarmEntity {
  const AlarmModel({
    required super.id,
    required super.title,
    required super.hour,
    required super.minute,
    required super.isActive,
  });

  AlarmModel copyWith({
    int? id,
    String? title,
    int? hour,
    int? minute,
    bool? isActive,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
    );
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
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
