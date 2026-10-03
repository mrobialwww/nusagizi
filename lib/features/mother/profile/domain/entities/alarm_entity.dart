import 'package:equatable/equatable.dart';

class AlarmEntity extends Equatable {
  final int id;
  final String title;
  final int hour;
  final int minute;
  final bool isActive;

  const AlarmEntity({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, title, hour, minute, isActive];
}
