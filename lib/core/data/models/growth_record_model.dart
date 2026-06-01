import '../../domain/entities/growth_record.dart';

class GrowthRecordModel extends GrowthRecord {
  const GrowthRecordModel({
    required super.date,
    required super.weight,
    required super.height,
    required super.headCircumference,
  });

  factory GrowthRecordModel.fromJson(Map<String, dynamic> json) {
    return GrowthRecordModel(
      date: DateTime.parse(json['date']),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      headCircumference: (json['headCircumference'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'height': height,
      'headCircumference': headCircumference,
    };
  }
}
